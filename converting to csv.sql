use project ;
SELECT 
    f.measurement_id,
    f.id,
    f.N_days,
    f.Age,
    f.Sex,
    f.Ascites,
    f.Hepatomegaly,
    f.Spiders,
    f.Edema,
    f.Bilirubin,
    f.Cholesterol,
    f.Albumin,
    f.Copper,
    f.Alk_Phos,
    f.SGOT,
    f.Tryglicerides,
    f.Platelets,
    f.Prothrombin,
    d.drug,
    d.stage,
    d.status
FROM 
    FactMedicalMeasurements f
JOIN 
    DimPatient d 
ON 
    f.id = d.id;

