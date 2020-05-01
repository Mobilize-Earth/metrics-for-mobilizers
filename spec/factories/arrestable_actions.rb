FactoryBot.define do
  factory :arrestable_action do
    xra_members { 1 }
    xra_not_members { 1 }
    trained_arrestable_present { 1 }
    arrested { 1 }
    days_event_lasted { 1 }
    report_comment { "MyText" }
    type_arrestable_action {'Local (50+)'}
  end
end
