class Role < ActiveRecord::Base
    enum roles: { consumer: "Other Data Consumer" , external: "External Coordinator", admin: "Administration" }
  end