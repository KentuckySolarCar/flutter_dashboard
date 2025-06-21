
#ifndef UKSC_Alert_H
#define UKSC_Alert_H

#include "FlexCAN_T4.h"
#include "ChRt.h"
#include "alertEnums.h"

#define ALERT_CAN_ID 0x110
#define ALERT_BUFFER_SIZE 32 // How many alerts to queue before discarding low priority ones
#define ALERT_EQUALITY_TOLERANCE 50 // Percentage wiggle room

class Alert {

    private:

    //  --private variables--
    // These variables are encoded and sent over CAN
	board_t snitch;
    alertCode_t code;
    severity_t severity;
	uint8_t itemNum;
	int8_t arg1;
    union { // This union allows you to either store two 16 bit values or one 32 bit value (timespans are usually 32 bit)
            // Using the union allows the Alert class to be multipurpose but not be too large to encode into a CAN_message_t
        struct {
	        int16_t arg2;
	        int16_t arg3;
        };
        uint32_t arg4;
    };

    // All other variables are not sent
    uint32_t timeReported;
    uint8_t dupeCnt;

    static Alert suppressedLog[ALERT_BUFFER_SIZE];
    static int suppressedSize;

    //  --private functions--
    void sortAlertLog();
	
    public:
    //  --public variables--
    static Alert alertLog[ALERT_BUFFER_SIZE];
    static int logSize;

    //  --constructors--
    Alert();
    Alert(const CAN_message_t& alertMsg);
    Alert(const Alert& alrt);
    Alert(board_t sni, alertCode_t type, severity_t sev);

    //  --public functions--
    void toCAN_message(CAN_message_t& alertMsg);
	void toSerial();
	void fromMsg(CAN_message_t msg); // called as Alert myAlert; myAlert.fromMsg(myMsg)
    void static suppressAlert();
    void static dismissAlert();
    inline bool static isAlertMsg(CAN_message_t msg){return ((msg.id & 0xFF0) == ALERT_CAN_ID);}
    inline void static addToAlertLog(CAN_message_t msg){
        // the Alert constructor from CAN msg automatically adds a copy of it to the log
        Alert newAlert(msg);
        // and then the Alert object leaves scope and gets effortlessly deallocated :)
    }

    //  --getters--
    inline board_t getSnitch() {return snitch;}
    inline alertCode_t getAlertCode() {return code;}
    inline severity_t getSeverity() {return severity;}
    inline uint8_t getItemNum() {return itemNum;}
    inline int8_t getArg1() {return arg1;}
    inline int16_t getArg2() {return arg2;}
    inline int16_t getArg3() {return arg3;}
    inline uint32_t getArg4() {return arg4;}
    inline uint32_t getTimeReported() {return timeReported;}
    inline uint8_t getDupeCnt() {return dupeCnt;}

    //  --setters--
    inline void setSnitch(board_t sni) {snitch = sni;}
    inline void setAlertCode(alertCode_t type) {code = type;}
    inline void setSeverity(severity_t sev) {severity = sev;}
    inline void setItemNum(uint8_t num) {itemNum = num;}
    inline void setArg1(int8_t arg) {arg1 = arg;}
    inline void setArg2(int16_t arg) {arg2 = arg;} // (32767 max positive)
    inline void setArg3(int16_t arg) {arg3 = arg;}
    inline void setArg4(uint32_t arg) {arg4 = arg;}
    inline void setDupeCnt(uint8_t cnt) {dupeCnt = cnt;} // Probably for testing only


    //  --operators--
    bool operator==(const Alert& alrt);
    bool operator>(const Alert& alrt);
    void operator+=(const Alert& alrt);
};

#endif