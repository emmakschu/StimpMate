class Stimp < ActiveRecord::Base

  def self.woodsNative()
    where("course = 'woods'").where("soilType = 'native'")
  end

  def self.woodsSand()
    where("course = 'woods'").where("soilType = 'sand'")
  end

  def self.prairieNative()
    where("course = 'prairie'").where("soilType = 'native'")
  end

  def self.prairieSand()
    where("course = 'prairie'").where("soilType = 'sand'")
  end

  def lakesNative()
    where("course = 'lakes'").where("soilType = 'native'")
  end

  def lakesSand()
    where("course = 'lakes'").where("soilType = 'sand'")
  end
end
