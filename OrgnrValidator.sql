# Norwegian organisasjonsnummer validator function for MySQL
# Provided by http://github.com/eydn
DELIMITER |
DROP FUNCTION IF EXISTS VALIDATEORG |
CREATE FUNCTION VALIDATEORG(ORGNR INT) RETURNS TINYINT DETERMINISTIC
    BEGIN
        #WEIGHTS = "3, 2, 7, 6, 5, 4, 3, 2";
        DECLARE RESULT          TINYINT;
        DECLARE WEIGHTS         INT DEFAULT 32765432;
        DECLARE SUM             INT DEFAULT 0;
        DECLARE CONTROL_NUMBER  INT DEFAULT RIGHT(ORGNR, 1);
        DECLARE COUNTER         INT DEFAULT 1;
        DECLARE REST            INT DEFAULT 0;
        DECLARE MODULUS         INT DEFAULT 11;
         
        IF LENGTH(ORGNR) != 9 THEN
            SET RESULT = 0;
        ELSE
            WHILE COUNTER < LENGTH (ORGNR) DO
                BEGIN
                    SET SUM     = SUM + ( SUBSTRING(ORGNR, COUNTER, 1) * SUBSTRING(WEIGHTS, COUNTER, 1) );
                    SET COUNTER = COUNTER + 1;
                END;
            END WHILE;
             
            SET REST = SUM % MODULUS;
             
            IF ( (MODULUS - REST) % MODULUS) = CONTROL_NUMBER THEN
                SET RESULT = 1;
            ELSE
                SET RESULT = 0;
            END IF;           
        END IF;
         
        RETURN RESULT;
    END;
|
DELIMITER ;