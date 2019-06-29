module Pod

  class ConfigureIOS
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform

        keep_demo = :yes

        framework = :None
        
        configurator.set_test_framework("xctest", "m")

    snapshots = :No

    prefix = nil

    loop do
        
        puts '--- 用户中心：UM，资源中心：RM，契约中心：CM，任务中心：TM，钱仓：MM，综合：OM，非业务组件：SA ---'.green
        
        prefix = configurator.ask("What is your class prefix")
        
        if prefix.include?(' ')
            puts 'Your class prefix cannot contain spaces.'.red
            else
            break
        end
    end

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "templates/ios/Example/PROJECT.xcodeproj",
        :platform => :ios,
        :remove_demo_project => (keep_demo == :no),
        :prefix => prefix
      }).run
      
      # There has to be a single file in the Classes dir
      # or a framework won't be created, which is now default
      `touch Pod/Classes/ReplaceMe.m`
      `touch Pod/Assets/NAME.xcassets`

      `mv ./templates/ios/* ./`
    end
  end

end
