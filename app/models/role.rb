class Role < ActiveRecord::Base
    enum roles: { reviewer: "Data Reviewer" , external: "External Coordinator", admin: "Administrator" }
end