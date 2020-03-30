# Climate Movement Reporting Tool

It will allow local chapters to input relevant data and enable the centralized collection, reporting, and communication of the overall impact of decentralized climate movements. 

# Install

```bash
git clone git@gitlab.com:climate-movement-reporting-tool/climate-movement-reporting-tool.git
```

# Set up

```bash
# gem install bundler
bundle
```
 
# Tests

## rSpec

```.bash
bundle exec rspec
```

## Cucumber

```.bash
bundle exec cucumber
```

## Test that everything's ok

```bash
bundle exec rspec spec/canary_spec.rb
bundle exec cucumber features/canary.feature
```

