'''
HELPER FILE FOR THE PART 2 OF THE PROJECT (TO CREATE A VISUALIZATION OF THE DECISION TREE)

- Helper files for the project to create a visualization of the decision tree
- This file is not used in the project but helps to understand perspective of the project (decisionTree.pl)
- When you run this file, you will see a graph that shows the visualization of the decision tree

'''

from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier, export_graphviz
import graphviz

# Load the Iris dataset
iris = load_iris()
X = iris.data
y = iris.target

# Create a decision tree classifier
clf = DecisionTreeClassifier(max_depth=3) # def

# Fit the classifier to the data
clf.fit(X, y)

# Export the decision tree to a DOT format
dot_data = export_graphviz(clf, out_file=None, 
                         feature_names=iris.feature_names,  
                         class_names=iris.target_names,  
                         filled=True, rounded=True,  
                         special_characters=True)  

# Visualize the decision tree using graphviz
graph = graphviz.Source(dot_data)
graph.render("iris_decision_tree")  # Save the visualization to a file
graph.view("iris_decision_tree")    # Open the visualization in the default viewer

# for value : 5.1, 3.5, 1.4, 0.2, setosa
# for value : 5.8, 2.7, 5.1, 1.9 virginica
# for value : 6.0, 2.2, 4.0, 1.0 versicolor

