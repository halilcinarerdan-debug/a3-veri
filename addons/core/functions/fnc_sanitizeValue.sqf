#include "..\script_component.hpp"
/*
 * Author: VBS COIN
 * extDB3'e array-form callExtension ile gonderilecek tek bir parametreyi
 * guvenli/tutarli hale getirir. Array-form callExtension ham SQF tiplerini
 * (STRING/SCALAR) dogrudan tasidigi icin manuel string-escape gerekmez;
 * burada yapilan tek is float hassasiyetini sabitlemek ve beklenmeyen
 * tipleri (ARRAY, OBJECT, vb.) guvenle stringe cevirmektir.
 *
 * Arguments:
 * 0: Ham deger <ANY>
 *
 * Return Value:
 * extDB3'e gonderime hazir deger <STRING, SCALAR>
 *
 * Public: no
 */

params ["_value"];

switch (typeName _value) do {
    case "SCALAR": {
        round (_value * 100) / 100
    };
    case "BOOL": {
        if (_value) then {1} else {0}
    };
    case "STRING": {
        _value
    };
    default {
        str _value
    };
};
