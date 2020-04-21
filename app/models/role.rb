class Role < ActiveRecord::Base
    enum roles: { reviewer: "Other Data Reviewer" , external: "External Coordinator", admin: "Administrator" }
end