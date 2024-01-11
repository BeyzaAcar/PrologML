'''
HELPER FILE FOR THE PART 2 OF THE PROJECT (from the documentation of the Iris dataset)

- Helper files for the project to get the general information about the dataset
- This file is not used in the project but helps to understand perspective of the project (decisionTree.pl)
- When you run this file, you will see the general information about the dataset (iris.data)

'''

from ucimlrepo import fetch_ucirepo 

# fetch dataset 
iris = fetch_ucirepo(id=53) 
  
# data (as pandas dataframes) 
X = iris.data.features 
y = iris.data.targets 
  
# metadata 
print(iris.metadata) 
  
# variable information 
print(iris.variables) 

# print the all dataset in Iris
print(iris.data)

