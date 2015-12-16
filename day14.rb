require_relative 'helpers'
require 'rspec'
require 'pry'

    class Reindeer
      attr_accessor :name, :state, :speed, :fly_duration, :rest_duration, :clock, :distance, :points

      def initialize(name, speed, fly_duration, rest_duration)
        self.name = name
        self.speed = speed.to_i
        self.fly_duration = fly_duration.to_i
        self.rest_duration = rest_duration.to_i

        # Initialize
        self.state = :flying
        self.clock = 0
        self.distance = 0
        self.points = 0
      end

      def tick!
        self.clock += 1
        self.distance += speed if flying?

        # Determine state after
        if flying? && clock == fly_duration
          self.state = :resting
          self.clock = 0
        elsif resting? && clock == rest_duration
          self.state = :flying
          self.clock = 0
        end

      end

      def flying?
        state == :flying
      end

      def resting?
        state == :resting
      end

      def add_point!
        self.points += 1
      end
    end

    reindeers = []
    reindeer_points = {}

    File.open('day14.txt').readlines.each do |line|
      _, name, speed, fly_duration, rest_duration = line.match(/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds/).to_a

      reindeers << Reindeer.new(name, speed, fly_duration, rest_duration)
      reindeer_points[name] = 0
    end

    2503.times do
      reindeers.map(&:tick!)

      highest_distance = reindeers.sort_by { |r| r.distance }.last.distance

      reindeers.each do |reindeer|
        reindeer.add_point! if reindeer.distance == highest_distance
      end
    end

    puts reindeers.sort_by { |r| r.points }.map(&:inspect)

