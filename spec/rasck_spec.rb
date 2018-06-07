RSpec.describe Rasck do
  it 'has a version number' do
    expect(Rasck::VERSION).not_to be nil
  end

  describe 'configure' do
    it 'stores endpoint' do
      Rasck.configure do |c|
        c.endpoint = 'endpoint'
      end
      expect(Rasck.config.endpoint).to eq('endpoint')
    end

    it 'stores redis_url' do
      Rasck.configure do |c|
        c.redis_url = 'redis://localhost:6379'
      end
      expect(Rasck.config.redis_url).to eq('redis://localhost:6379')
    end

    it 'adds custom check' do
      Rasck.configure do |c|
        c.add_custom_check 'check' do
          true
        end
      end
      expect(Rasck.config.custom_checks).to include('check')
    end

    it 'stores auth_token' do
      Rasck.configure do |c|
        c.auth_token = 'TOKEN'
      end
      expect(Rasck.config.auth_token).to eq('TOKEN')
    end
  end

  describe 'all_checks' do
    context 'When there are custom_checks' do
      before do
        Rasck.config = nil
        Rasck.configure do |c|
          c.add_custom_check 'check-1' do
            true
          end
          c.add_custom_check 'check-2' do
            true
          end
        end
      end

      it 'returns built-in checks + custom checks' do
        expect(Rasck.all_checks.keys).to eq(%w[redis s3 check-1 check-2])
      end
    end
  end

  describe 'run_checks' do
    context 'When there are new custom checks' do
      before do
        Rasck.config = nil
        Rasck.configure do |c|
          c.add_custom_check 'check-1' do
            true
          end
          c.add_custom_check 'check-2' do
            true
          end
        end
      end

      it 'returns custom checks results' do
        expect(Rasck.run_checks).to eq(
          'check-1' => true,
          'check-2' => true,
          'redis' => false,
          's3' => false
        )
      end
    end

    context 'When custom checks overrides built-in checks' do
      before do
        Rasck.config = nil
        Rasck.configure do |c|
          c.add_custom_check 'check-1' do
            true
          end
          c.add_custom_check 'redis' do
            'redis-override'
          end
          c.add_custom_check 's3' do
            's3-override'
          end
        end
      end

      it 'returns custom checks results' do
        expect(Rasck.run_checks).to eq(
          'check-1' => true,
          'redis' => 'redis-override',
          's3' => 's3-override'
        )
      end
    end
  end
end
