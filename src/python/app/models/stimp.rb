class Stimp < ActiveRecord::Base

  def self.woodsNative()
    where("course = 'woods'").where("soilType = 'native'").order("created_at DESC")
  end

  def self.woodsSand()
    where("course = 'woods'").where("soilType = 'sand'").order("created_at DESC")
  end

  def self.prairieNative()
    where("course = 'prairie'").where("soilType = 'native'").order("created_at DESC")
  end

  def self.prairieSand()
    where("course = 'prairie'").where("soilType = 'sand'").order("created_at DESC")
  end

  def self.lakesNative()
    where("course = 'lakes'").where("soilType = 'native'").order("created_at DESC")
  end

  def self.lakesSand()
    where("course = 'lakes'").where("soilType = 'sand'").order("created_at DESC")
  end
end
