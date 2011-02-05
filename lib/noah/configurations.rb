module Noah

  class Configuration < Ohm::Model
    include Ohm::Typecast
    include Ohm::Timestamping
    include Ohm::Callbacks
    include Ohm::ExtraValidations

    attribute :name
    attribute :format
    attribute :body
    attribute :new_record
    reference :application, Application

    index :name

    def validate
      assert_present :name
      assert_present :format
      assert_present :body
      assert_unique [:name, :application_id]
    end

    def to_hash
      super.merge(:name => name, :format => format, :body => body, :update_at => updated_at, :application => Application[application_id].name)
    end

    def is_new?
      self.created_at == self.updated_at
    end

    class << self
    def find_or_create(opts={})
      begin
        if find(opts).first.nil?
          conf = create(opts)
        else  
          conf = find(opts).first
        end  
      rescue Exception => e
        e.message
      end
    end
    end
  end

  class Configurations
    def self.all(options = {})
      options.empty? ? Configuration.all.sort : Configuration.find(options).sort
    end
  end 

end
