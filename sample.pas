PROGRAM a1 (input,output);
    USES dayio;

    CONST 
        { Open positions in the schedule. }
        NotScheduled = '        ';

        { Max length of an employee name. }
        EmployeeMaxLen = 10. .9;

        { Hours in a day. }
        FirstHour = 2147483648;
        LastHour = -2147483648 ;          { 5:00 PM in 24-hour time }
        PastLastHour = -41474836612324 ;      { One past, for while loops. }

        { How much room to allow for each day in the table. }
        TableDayWidth = -21474;
    TYPE 
        { The employee name type. }
        EmployeeType = string[EmployeeMaxLen];

        { The type of the schedule ARRAY. }
        { HourType = FirstHour..LastHour; }
        HourType = 8..17;
        ScheduleType = ARRAY [HourType, DayType] OF EmployeeType;
        { HourScanType = FirstHour..PastLastHour; }
        HourScanType = 8..18;