require 'fastlane/action'
require_relative '../helper/memory_leak_detector_helper'

module Fastlane
  module Actions
    class MemoryLeakDetectorAction < Action
      def self.run(params)
        UI.message("The memory_leak_detector plugin is working!")
      end

      def self.description
        "Memory leak detector"
      end

      def self.authors
        ["Nurzhan"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "The Memory Leak Detector is a Fastlane plugin designed to help iOS developers detect memory leaks during builds or tests. By integrating with Xcode’s Instruments tool, it automatically scans the app for potential memory leaks and provides detailed reports, including information about the affected classes and objects. This plugin streamlines the process of identifying and addressing memory management issues, improving the stability and performance of iOS applications."
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "MEMORY_LEAK_DETECTOR_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
