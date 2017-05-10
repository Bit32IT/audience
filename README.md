# Audience

Audience allows you to segment your application's users using regular Ruby
classes. A "segment" is a subgroup that all share certain characteristics.
After defining a segment, you will be able to iterate through all users in the
segment, check if a specific user belongs to the segment, and add/remove users
to the segment. This decouples the segmentation interface from the
implementation of the underlying grouping, reducing code repetition across your
application.

Audience is built on Rails, but otherwise does not assume any particular
database or ORM.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'audience'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install audience

Then run:

    $ rails g audience:install

In your user or member model, add:

```ruby
class User
  include Audience::Segmentable
end
```

## Basic Segment

Suppose we want to send an email to all female users who are between the age of
18 - 25 who have been registered on the site more than a year. Kind of a pain
right? We can define this kind of segment easily with Audience. Run:

    $ rails g audience:segment loyal_female_millenials

This will generate a segment in `app/segments` and register it for you in
`config/initializers/audience.rb`.

Open up `app/segments/loyal_female_millenials.rb` and add:

```ruby
class LoyalFemaleMillenialsSegment < ApplicationSegment
  def members
    User.where(gender: 'F', age: 18..25).where("created_at > ?", 1.year.ago)
  end

  def include?(user)
    user.gender == 'F' &&
      (18..25).include?(user.age) &&
      user.created_at < 1.year.ago
  end
end
```

Looking in `config/initializers/audience.rb`, we can see that the segment has been
registered with a unique name.

```ruby
Audience.register_segment :loyal_female_millenials, Audience::Segment::LoyalFemaleMillenials.new
```

Now we can iterate through all users in this segment like so to send them an email:

```ruby
User.segment(:loyal_female_millenials).each do |user|
  MarketingEmailMailer.campaign(user).deliver_later
end
```

We can also check if a specific user belongs to this segment:

```ruby
if curent_user.in_segment?(:loyal_female_millenials)
  @show_marketing_blurb = true
end
```

## Mutable Segments

Suppose you have a segment defined by membership in an arbitrarily chosen marketing group.
You want to be able to add and remove users from this segment easily. Let's define a segment
that allows this to be done easily without leaking the implementation all over the app.

    $ rails g audience:segment arbitrary_marketing_group

```ruby
class ArbitraryMarketingGroupSegment < ApplicationSegment
  def members
    group.members
  end

  def include?(user)
    group.members.include?(user)
  end

  def add(user)
    group.add(user)
  end

  def remove(user)
    group.remove(user)
  end

  private

  def group
    @group ||= Group.find(:arbitrary_marketing_group)
  end
end
```

Now, in addition to iterating through the segment members and checking if a user belongs
to the segment, we can also add users to the segment and remove them:

```ruby
user.add_to_segment(:arbitrary_marketing_group)
user.remove_from_segment(:arbitrary_marketing_group)

# Equivalent

User.segment(:arbitrary_marketing_group).add(user)
User.segment(:arbitrary_marketing_group).remove(user)
```

## Reusable Segments

Suppose we want to segment users into 20 different cities, and send a slightly different version
of a marketing email to each city. We can create one reusable segment, and use that to register 20
different segments, one for each city. Let's see how we can do that. In this example, we'll use the
[Postgres earthdistance](https://github.com/diogob/activerecord-postgres-earthdistance) extension.

    $ rails g audience:segment location

```ruby
class LocationSegment < ApplicationSegment
  def initialize(latitude:, longitude:, distance: 20)
    @latitude = latitude
    @longitude = longitude
    @distance = distance
  end

  def members
    User.within_radius(@distance, @latitude, @longitude)
  end

  def include?(user)
    members.where(id: user.id).exists?
  end
end
```

Now we can register different segments for different cities! Open up
`config/initializers/audience.rb` and add as many cities as you need:

```ruby
Audience.register_segment :london, LocationSegment.new(latitude: 51.508515, longitude: -0.125487)
Audience.register_segment :los_angeles, LocationSegment.new(latitude: 34.052234, longitude: -118.243685, distance: 50)
# etc.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/audience. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

