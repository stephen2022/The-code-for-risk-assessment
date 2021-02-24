
#SMOTE for bank data12 form Stephen Oct.2021

import pandas as pd
from imblearn.over_sampling import SMOTE 
 
# Data reading
data3 = pd.read_excel(r'C:\Users\Ashley\Desktop\HXbank_DataA\E_Data12.xlsx')

# Choose the column
column3 = [u'CC',u'BS',u'FIR',u'IR',u'ICF',u'CIR',u'AGA',u'SGR',u'VP',u'IC',u'ES',u'CS',u'ET',u'BNRO',u'OD',u'DIS']

data3.columns = column3

x3=data3.iloc[:,1:16] 
y3=data3.iloc[:,0] 

groupby_data_orgianl3 = data3.groupby('CC').count() 
print('----The original data  distribution-----')
print (groupby_data_orgianl3) # Print it

names3=[u'CC',u'BS',u'FIR',u'IR',u'ICF',u'CIR',u'AGA',u'SGR',u'VP',u'IC',u'ES',u'CS',u'ET',u'BNRO',u'OD',u'DIS']

# Build SMOTE model and SMOTE Using
model_smote = SMOTE() 
x_smote_resampled3, y_smote_resampled3 = model_smote.fit_sample(x3,y3) 
x_smote_resampled3 = pd.DataFrame(x_smote_resampled3, columns=names3) 
y_smote_resampled3 = pd.DataFrame(y_smote_resampled3,columns=['CC']) 
smote_resampled3 = pd.concat([x_smote_resampled3,y_smote_resampled3],axis=1) 
df_smote3=pd.DataFrame(smote_resampled3)
df_smote3.to_excel(r'C:\Users\Ashley\Desktop\HXbank_DataA\E_Data12_Smote.xlsx')

groupby_data_smote3 = smote_resampled3.groupby('CC').count() # label classification
print('----The SMOTE data  distribution-----')
print (groupby_data_smote3) # Print it






