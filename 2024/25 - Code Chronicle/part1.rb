require './lib/solution_helper'

helper = SolutionHelper.new(dir: File.dirname(__FILE__))

class Key
  attr_reader :levels

  def initialize(key)
    @levels = read(key)
  end

  def read(key)
    rows   = key.lines
    levels = Array.new(5) { 0 }
    rows[..-2].each do |row|
      row.chars.each_with_index do |char, i|
        levels[i] += 1 if char == '#'
      end
    end
    levels
  end
end

class Lock
  attr_reader :levels

  def initialize(lock)
    @levels = read(lock)
  end

  def read(lock)
    rows   = lock.lines
    levels = Array.new(5) { 0 }
    rows[1..].each do |row|
      row.chars.each_with_index do |char, i|
        levels[i] += 1 if char == '#'
      end
    end
    levels
  end

  def fits?(key)
    key.levels.each_with_index do |level, i|
      return false if levels[i] + level > 5
    end
    true
  end
end

class DoorSimulator
  attr_reader :locks, :keys

  def initialize(input)
    @keys  = []
    @locks = []
    parse(input)
  end

  def overlapping_count
    overlaps = 0
    @keys.each do |key|
      @locks.each do |lock|
        overlaps += 1 if lock.fits?(key)
      end
    end
    overlaps
  end

  private

  def parse(input)
    graphs = input.split("\n\n")

    graphs.each do |graph|
      graph.chomp!
      @keys << Key.new(graph) if key?(graph)
      @locks << Lock.new(graph) if lock?(graph)
    end
  end

  def key?(graph)
    graph.lines.last.chomp == '#####'
  end

  def lock?(graph)
    graph.lines.first.chomp == '#####'
  end
end

simulator = DoorSimulator.new(helper.input)
puts simulator.overlapping_count
