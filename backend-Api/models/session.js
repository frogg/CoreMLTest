"use strict";

module.exports = function(sequelize, DataTypes) {
  var Session = sequelize.define("Session", {
    starttime: DataTypes.STRING,
    phoneModel: DataTypes.STRING,
    isAnalysisComplete: DataTypes.BOOLEAN
  });
  
  return Session;
};