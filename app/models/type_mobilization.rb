class TypeMobilization < ActiveRecord::Base
    enum types: { in_person: "In Person" , virtual: "Virtual" }
end