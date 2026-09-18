class CfgFunctions
{
    class VBS
    {
        class Layer1_Population
        {
            file = "vbs_layer1_population\functions";

            class initPopulation           { postInit = 0; };
            class scanCivilianBuildings    {};
            class classifyBuilding         {};
            class generateCivilian         {};
            class insertCivilianAsync      {};
            class extensionCallback        {};
        };
    };
};
