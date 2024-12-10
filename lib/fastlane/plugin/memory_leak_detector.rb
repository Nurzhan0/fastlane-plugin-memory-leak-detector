require 'fastlane/plugin/memory_leak_detector/version'

module Fastlane
  module Actions
    class MemoryLeakDetectorAction < Action
      def self.run(params)
        UI.message("Running Memory Leak Detection...")

        # Optional: Set the Xcode scheme and configuration for testing
        scheme = params[:scheme]
        configuration = params[:configuration]
        output_file = params[:output_file] || "memory_leak_report.txt" # Default to a text file

        # Run the Instruments command to detect memory leaks
        command = "xcrun instruments -t 'Leaks' -D '#{output_file}' #{scheme} #{configuration}"
        
        # Execute the command to detect memory leaks
        result = sh(command)

        # Check if the command's result indicates any leaks
        if result.include?("leak detected")
          UI.error("Memory leak detected!")
          # Capture and save the details of the leak to a file
          save_report(output_file)
        else
          UI.success("No memory leaks detected!")
          save_report(output_file, no_leaks: true)
        end
      end

      def self.save_report(output_file, no_leaks: false)
        # If no leaks are detected, output a clean "No leaks" message
        if no_leaks
          File.open(output_file, 'w') do |file|
            file.puts "Memory Leak Report - No leaks detected"
            file.puts "Timestamp: #{Time.now}"
          end
        else
          # If leaks are detected, provide detailed information in the report
          leak_details = get_leak_details(output_file)

          File.open(output_file, 'w') do |file|
            file.puts "Memory Leak Report - Leaks Detected"
            file.puts "Timestamp: #{Time.now}"
            file.puts "Leak details:"

            leak_details.each_with_index do |leak, index|
              file.puts "Leak ##{index + 1}:"
              file.puts "Class: #{leak[:class]}"
              file.puts "Object: #{leak[:object]}"
              file.puts "File: #{leak[:file]}"
              file.puts "Line: #{leak[:line]}"
              file.puts "Stack trace: #{leak[:stack_trace]}"
              file.puts "Retained reference count: #{leak[:ref_count]}"
              file.puts "-" * 50
            end
          end
        end

        UI.message("Report saved to #{output_file}")
      end

      # Simulated function to extract leak details from the Instruments log
      def self.get_leak_details(output_file)
        # Example of what the leak details might look like
        # You would replace this part with logic to parse Instruments output
        # and extract the actual leak details.
        leaks = [
          {
            class: "MyClass",
            object: "MyObject",
            file: "MyClass.swift",
            line: 42,
            stack_trace: "SomeStackTrace -> SomeMethod",
            ref_count: 2
          },
          {
            class: "AnotherClass",
            object: "AnotherObject",
            file: "AnotherClass.swift",
            line: 35,
            stack_trace: "AnotherStackTrace -> AnotherMethod",
            ref_count: 3
          }
        ]
        
        leaks
      end

      def self.description
        "Detect memory leaks in your app during builds or tests and generate a detailed report"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       description: "The Xcode scheme to use",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :configuration,
                                       description: "The build configuration (e.g., Debug, Release)",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :output_file,
                                       description: "The output file for the memory leak report",
                                       optional: true,
                                       type: String,
                                       default_value: "memory_leak_report.txt")
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end

