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
      it 'returns built_in_checks + custom_checks' do
        expect(Rasck.all_checks).to eq(%w[redis s3 check-1 check-2])
      end
    end
  end

  describe 'run_checks' do
    context 'When there are custom checks' do
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

      context 'And S3 and Redis are not defined' do
        it 'returns custom checks results' do
          expect(Rasck.run_checks).to eq(
            'check-1' => true,
            'check-2' => true
          )
        end
      end

      context 'And Redis is defined' do
        before do
          conn = double(:conn, ping: 'PONG')
          stub_const('Redis', Class.new)
          allow(Redis).to receive(:new).and_return(conn)
        end

        it 'includes redis check' do
          expect(Rasck.run_checks).to eq(
            'redis' => true,
            'check-1' => true,
            'check-2' => true
          )
        end
      end

      context 'And Aws is defined' do
        before do
          res = double(:res, successful?: true)
          s3 = double(:s3, list_buckets: res)
          stub_const('Aws::S3::Client', Class.new)
          allow(Aws::S3::Client).to receive(:new).and_return(s3)
        end

        it 'includes s3 check' do
          expect(Rasck.run_checks).to eq(
            's3' => true,
            'check-1' => true,
            'check-2' => true
          )
        end
      end
    end
  end
end
