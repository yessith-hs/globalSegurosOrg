/**
********************************************************************************************************
* @company         Avanxo Colombia
* @author          Antonio Torres href=<atorres@avanxo.com>
* @proyect         Global Seguros
* @name            OrgWideLimit_cls
* @description     Class to handle org wide limit values from a salesforce org.
* @dependencies    None
* @changes (Version)
* --------   ---   ----------   ---------------------------   ------------------------------------------
*            No.   Date         Author                        Description
* --------   ---   ----------   ---------------------------   ------------------------------------------
* @version   1.0   2016-06-23   Antonio Torres (AT)           Creation of the class.
********************************************************************************************************
**/

public with sharing class OrgWideLimit_cls {
    private String strName;
    private Integer intMaxValue;
    private Integer intRemainingValue;
    
    public OrgWideLimit_cls(String strName) {
        this.strName        = strName;
        intMaxValue         = -1;
        intRemainingValue   = -1;
    }

    /**
    * @method       getMax
    * @description  Returns the max value of the org wide limit.
    * @author       Antonio Torres - 2016-06-23
    */
    public Integer getMax() {
        return intMaxValue;
    }

    /**
    * @method       getRemaining
    * @description  Returns the remaining value of the org wide limit.
    * @author       Antonio Torres - 2016-06-24
    */
    public Integer getRemaining() {
        return intRemainingValue;
    }

    /**
    * @method       getColumnNamesOfTypeOnReport
    * @description  Set the max value of the org wide limit.
    * @author       Antonio Torres - 2016-06-24
    */
    public void setMax(Integer intMaxValue) {
        this.intMaxValue = intMaxValue;
    }

    /**
    * @method       getColumnNamesOfTypeOnReport
    * @description  Set the remaining value of the org wide limit.
    * @author       Antonio Torres - 2016-06-24
    */
    public void setRemaining(Integer intRemainingValue) {
        this.intRemainingValue = intRemainingValue;
    }
}