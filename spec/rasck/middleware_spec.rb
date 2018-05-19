RSpec.describe Rasck::Middleware do
  subject { Rasck::Middleware.new(app) }
  let(:app) { double(:app) }

  before do
    Rasck.config = nil
    Rasck.configure do |c|
      c.endpoint = '/status'
    end
    allow(Rasck).to receive(:run_checks).and_return(
      'redis' => true,
      's3' => true,
      'check-1' => true
    )
  end

  describe 'call' do
    context 'When request url matches endpoint' do
      let(:env) { { 'PATH_INFO' => '/status' } }

      it 'return json response' do
        expect(subject.call(env)).to eq(
          [
            200,
            { 'Content-Type' => 'application/json' },
            ["{\"redis\":true,\"s3\":true,\"check-1\":true}"]
          ]
        )
      end
    end

    context 'When request url does not match endpoint' do
      let(:env) { { 'PATH_INFO' => 'wrong' } }

      it 'passes env to the next middleware' do
        expect(app).to receive(:call).with(env)
        subject.call(env)
      end
    end
  end
end
