/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2022 HPCC Systems.  All rights reserved.
############################################################################## */
IMPORT python3 as python;
IMPORT ML_Core.Types as MTypes;
IMPORT $.^.Types as Types;
IMPORT $.^ as rffGPR;
IMPORT rffGPR.GPRI as GPRI;
IMPORT $ as rff;

// Generate test data
dataGen:= rff.M_dataGen(1000, 800);
dx_train := DISTRIBUTE(dataGen.x_train, 0): GLOBAL;
dy_train := DISTRIBUTE(dataGen.y_train, 0): GLOBAL;
dx_test := DISTRIBUTE(dataGen.x_test, 0): GLOBAL;
dy_test := DISTRIBUTE(dataGen.y_test, 0): GLOBAL;

// Python version GPR
pyGPR := rff.pyGPR(dx_train, dy_train);
// HPCC Systems version GPR
sess := GPRI.getSession();
m := GPRI.fit(sess, dx_train, dy_train, 500);
HPCCGPR := GPRI.predict(sess, m, dx_train);

// Compare R2 score
pyR2 := rff.score(dx_train, dy_train, pyGPR).r2;
HPCCR2 := rff.score(dx_train, dy_train, HPCCGPR).r2;

OUTPUT(pyR2, NAMED('pyR2'));
OUTPUT(HPCCR2, NAMED('HPCCR2'));