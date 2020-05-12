FactoryBot.define do
  factory :arrestable_action do
    mobilizers { 1 }
    not_mobilizers { 1 }
    trained_arrestable_present { 1 }
    arrested { 1 }
    days_event_lasted { 1 }
    report_comment { "MyText" }
    type_arrestable_action {'Local (50+)'}
  end
end
