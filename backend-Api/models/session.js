"use strict";

module.exports = function(sequelize, DataTypes) {
  var Session = sequelize.define("sessions", {
    starttime: DataTypes.STRING,
    phoneModel: DataTypes.STRING,
    isAnalysisComplete: DataTypes.BOOLEAN
  });
  
  return Session;
};