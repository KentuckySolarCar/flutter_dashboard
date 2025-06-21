#include "alert.h"

MUTEX_DECL(alertMtx);

//  --private variables--
Alert Alert::suppressedLog[ALERT_BUFFER_SIZE];
int Alert::suppressedSize = 0;

//  --public variables--
Alert Alert::alertLog[ALERT_BUFFER_SIZE];
int Alert::logSize = 0;

//  --private functions--
void Alert::sortAlertLog(){
    // Checks if new Alert is already suppressed    
    for (int i = 0; i < suppressedSize; i++){
        if (*this == suppressedLog[i]){
            return;
        }
    }

    chMtxLock(&alertMtx); //lock 1

    for (int i = 0; i < logSize; i++){
        if (*this == alertLog[i]){
            alertLog[i] += *this;
            chMtxUnlock(&alertMtx); //unlock 1-A
            return;

        } else if (*this > alertLog[i]){
            // Shift all the lesser Errors in the buffer over to make space
            for (int j = logSize; j > i; j--){
                if (j != ALERT_BUFFER_SIZE){  // If (j == ALERT_BUFFER_SIZE) the least important error is discarded entirely
                    alertLog[j] = alertLog[j-1];
                }
            }
            if (logSize < ALERT_BUFFER_SIZE) logSize++;

            alertLog[i] = *this;
            chMtxUnlock(&alertMtx); //unlock 1-B
            return;
        }
    }

    // This runs if this is the least significant error so far or the list is empty
    if (logSize < ALERT_BUFFER_SIZE) { // If (logSize == ALERT_BUFFER_SIZE) the incoming error is discarded entirely
        alertLog[logSize] = *this;
        logSize++;
        chMtxUnlock(&alertMtx); //unlock 1-C
        return;
    } 

    chMtxUnlock(&alertMtx); //unlock 1-D
}

//  --constructors--
Alert::Alert(){ // default constructor
    snitch = undefinedBoard;
    code = undefinedAlert;
    severity = undefinedSeverity;
    itemNum = 0;
    arg1 = 0;
    arg2 = 0;
    arg3 = 0;
    dupeCnt = 0;
}

Alert::Alert(const CAN_message_t& errMsg){ // CAN constructor
    severity = (severity_t)(errMsg.id & 0xF); // severity is decoded from the low 4 bits of the message ID
    memcpy(&snitch,  &errMsg.buf[0], sizeof(snitch));
    memcpy(&code,    &errMsg.buf[1], sizeof(code));
    memcpy(&itemNum, &errMsg.buf[2], sizeof(itemNum));
    memcpy(&arg1,    &errMsg.buf[3], sizeof(arg1));
    memcpy(&arg2,    &errMsg.buf[4], sizeof(arg2));
    memcpy(&arg3,    &errMsg.buf[6], sizeof(arg3));
    timeReported = millis();

    this->sortAlertLog(); // adds this Error to the alertLog
}

Alert::Alert(const Alert& err){ // copy constructor
    snitch = err.snitch;
    code = err.code;
    severity = err.severity;
    itemNum = err.itemNum;
    arg1 = err.arg1;
    arg2 = err.arg2;
    arg3 = err.arg3;
    dupeCnt = err.dupeCnt;
}

Alert::Alert(board_t sni, alertCode_t type, severity_t sev){
    snitch = sni;
    code = type;
    severity = sev;
    itemNum = 0;
    arg1 = 0;
    arg2 = 0;
    arg3 = 0;
    dupeCnt = 0;
}


//  -- public functions--
void Alert::toCAN_message(CAN_message_t& errMsg){
    /* 
     * Error class cannot be used to write directly to Can0
     * CAN_message_t's that it creates also seem to freeze the CANBus
     * Therefore users pass in a CAN_message_t and this populates it
     * and then they can send it themselves.
     * memcpy() also created bad CANBus behavior so bitdiddling was the
     * decided method for copying message contents. 
    */

    int id = ALERT_CAN_ID + severity;
    unsigned short one = (code << 8) + (snitch);
    unsigned short two = (arg1 << 8) + (itemNum);
    unsigned short three = arg2;
    unsigned short four = arg3;

    errMsg.flags.extended = false;
    errMsg.id = id; // severity is encoded in the low 4 bits of the message ID
    errMsg.len = 8;
    errMsg.ussss.one = one;
    errMsg.ussss.two = two;
    errMsg.ussss.three = three;
    errMsg.ussss.four = four;

    this->sortAlertLog();
}

void Alert::toSerial(){
    Serial.println("-----------ALERT INFO-----------");
    Serial.print("Snitch:     "); Serial.println(snitch);
    Serial.print("Alert Code: "); Serial.println(code);
    Serial.print("Severity:   "); Serial.println(severity);
    Serial.print("Item Num:   "); Serial.println(itemNum);
    Serial.print("Arg 1:      "); Serial.println(arg1);
    Serial.print("Arg 2:      "); Serial.println(arg2);
    Serial.print("Arg 3:      "); Serial.println(arg3);
    Serial.print("Time Stamp: "); Serial.println(timeReported);
    Serial.print("Dupe Count: "); Serial.println(dupeCnt);

}

void Alert::fromMsg(CAN_message_t errMsg){ // called as Error myError; myError.fromMsg(myMsg)
    severity = (severity_t)(errMsg.id & 0xF);
    memcpy(&snitch,  &errMsg.buf[0], sizeof(snitch));
    memcpy(&code,    &errMsg.buf[1], sizeof(code));
    memcpy(&itemNum, &errMsg.buf[2], sizeof(itemNum));
    memcpy(&arg1,    &errMsg.buf[3], sizeof(arg1));
    memcpy(&arg2,    &errMsg.buf[4], sizeof(arg2));
    memcpy(&arg3,    &errMsg.buf[6], sizeof(arg3));
}

void Alert::suppressAlert(){
    if (suppressedSize < ALERT_BUFFER_SIZE && logSize > 0) {
        suppressedLog[suppressedSize] = alertLog[0];
        suppressedSize++;
    }
    dismissAlert();
}

void Alert::dismissAlert(){
    chMtxLock(&alertMtx); //lock 2
    if (logSize > 0){
        for (int i = 0; i < (logSize - 1); i++){
            alertLog[i] = alertLog[i+1];
        }
        logSize--;
        Alert NULLErr;
        alertLog[logSize] = NULLErr;
    }
    chMtxUnlock(&alertMtx); //unlock 2
}


//  --operators--
bool Alert::operator==(const Alert& err){
    if (snitch == err.snitch &&
        severity == err.severity &&
        code == err.code &&
        itemNum == err.itemNum &&
        (abs((100 * (err.arg1 - arg1)) / arg1)) < ALERT_EQUALITY_TOLERANCE && // is within some % of current value
        (abs((100 * (err.arg2 - arg2)) / arg2)) < ALERT_EQUALITY_TOLERANCE && // is within some % of current value
        (abs((100 * (err.arg3 - arg3)) / arg3)) < ALERT_EQUALITY_TOLERANCE)   // is within some % of current value
        {
            return true;
        } else {
            return false;
        }
}

bool Alert::operator>(const Alert& err){
    // a higher severity is a lower number
    if (severity == undefinedSeverity) {
        return false;
    } else {
        return (severity < err.severity); // CRIT = 1, HIGH = 2, ..., INFO = 5
    }
}

void Alert::operator+=(const Alert& err){
    if (decltype(dupeCnt)(dupeCnt + 1) > dupeCnt) { // keeps overflow from happening regardless of dupeCnt type
        dupeCnt++;
    }

    // Replace args with the most up-to-date info. i.e. the most recent message's data
    arg1 = err.arg1;
    arg2 = err.arg2;
    arg3 = err.arg3;
}