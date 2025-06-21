#ifndef ERROR_ENUMS_H
#define ERROR_ENUMS_H

#include "stdint.h"

//*  --General error enums--
enum board_t : uint8_t {
    undefinedBoard,
    BPS,
    bottomShell,
    dashboard,
    topShell,
    steeringWheel,
    tritium_left,
    tritium_right
}; 

enum severity_t : uint8_t {
    undefinedSeverity,
    critical,
    high,
    middle,
    low,
    info
};

enum alertCode_t : uint8_t {
    undefinedAlert, // NULL
    overVoltage,            // masterboard: bps trip due to voltage
    underVoltage,
    outOfBalance,           // The modules are at different voltages, this reduces the ability to charge the pack at the high voltages and pull energy from the pack at low voltages
    overCurrent,            // masterboard: bps trip due to current
    underCurrent,
    overTemperature,        // masterboard: batteries are overtemp, tritium: motor/heatsink is overtemp
    underTemperature,
    killSwitch,
    currentLimited,
    auxLow,
    CAN_timeout,
    CAN_droppedFrames,
    CAN_sendFailure,
    CAN_recieveFailure,
    invalidID,
    loggingSnapshotFailure,
    noSD,
    sdLowOnSpace,
    sdOutOfSpace,
    bufferOverrun,
    tenVoltBusLow,
    subarrayIntermittent,
    subarrayMismatch,
    highResistance,         // If the motor controller voltage is significantly different from battery voltage
    motorControllerError,   // Check Tritium Wavesculptor documentation for more info on these
    noGPS,                  // The GPS hardware isn't present
    noGPSFix,               // The GPS cannot get a lock on its position
    GPSBad,                 // HDOP (The positional accuracy) is very poor
    outOfCalibrationRange,
    recalibrationFail,
    recalibrationOccured,
    fanOn,                   // Fan has turned on
    throttleInputError,
    prechargeFail
};


//*  --Alert-specific enums--
enum CAN_timeout_t : uint8_t {
    voltageTimeout =     0b001,
    temperatureTimeout = 0b010,
    currentTimeout =     0b100
}; // Stored in Alert.arg1

enum invalidID_t : uint8_t {
    voltageID, 
    temperatureID
}; // Stored in Alert.arg1

enum motorControllerError_t : uint8_t {
    SoftwareOverCurrent,
    DC_BusOverVoltage,
    badMotorPosition,       // Bad motor position hall sequence
    watchdogResetOccured,   // Watchdog caused last reset
    badConfigValues,        // Config read error (some values may be reset to defaults)
    underVoltLockOut_15V,   // 15V rail under voltage lock out (UVLO)
    desaturationFault,      // Desaturation fault (IGBT desaturation, IGBT driver UVLO)
    motorOverSpeed          // Motor Over Speed (15% overshoot above max RPM)
}; // Stored in Alert.arg1

enum outOfCalibrationRangeAlert_t : uint8_t {
    TrigThrot,
    TrigRegen,
    PedalThrot,
    PedalRegen
}; // Stored in Alert.arg1

enum calibrationError_t : uint8_t {
    tooQuick,
    rangeTooNarrow_TrigThrot,
    rangeTooNarrow_TrigRegen,
    rangeTooNarrow_PedalThrot,
    rangeTooNarrow_PedalRegen
}; // Stored in Alert.arg1

enum throttleInputError_t : uint8_t {
    totalThrottleFail, // Both triggers and hall effect are in fail state
    triggerFail, // Trigger in fail state
    hallEffectRangeFail, // Hall effect sensor values are too far apart
    hallEffectOneFail, // Hall effect sensor 1 (THROT1_IN) is not reading
    hallEffectTwoFail, // Hall effect sensor 2 (THROT2_IN) is not reading
    hallEffectTotalFail // Both hall effect sensors are not reading
}; // Stored in Alert.arg1

enum prechargeError_t : uint8_t {
    motorPrechargeFail,
    mpptPrechargeFail
};

#endif