describe Fastlane::Actions::MemoryLeakDetectorAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The memory_leak_detector plugin is working!")

      Fastlane::Actions::MemoryLeakDetectorAction.run(nil)
    end
  end
end
