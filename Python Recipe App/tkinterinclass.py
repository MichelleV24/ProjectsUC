import json
import tkinter as tk
import random
from tkinter import ttk, WORD


WINDOW_TITLE = "What can I Cook Today?"
BG_COLOUR = '#99A98F'
HL_COLOUR = '#D6E8DB'

class RecipeApp(object):
    """
    A Class used to generate a recipe application with GUI
    User ingredients are entered and matched against recipe dataset
    Returned are recipes with matching ingredients to the user's ingredients,
    random recipe generation method.
    """

    def __init__(self):
        """
        The initialisation function. This will set up the TKinter GUI with
        buttons, setting layout and text box.
        """

        self.window = tk.Tk() #initialises the tkinter window
        self.window.configure(bg = BG_COLOUR) #setting background colour for the window
        self.window.title(WINDOW_TITLE) #setting the title of the app as a global var

        self.title_label = tk.Label(master = self.window, 
                        text = 'Welcome! \nPlease enter your ingredients on hand', 
                        font = 'Calibri 24 bold',
                        background = BG_COLOUR) #First welcome label
        self.title_label.grid(column = 1, row = 0, padx = 5, pady =5) #welcome label is set in the GUI via grid, padding included to set some distance between objects
        
        self.sub_title_label = tk.Label(master = self.window,
                            text = 'Please seperate your ingredients with commas',
                            font = 'Calibri 16 italic',
                            background=  BG_COLOUR,
                            foreground= "#FFF8DE") #secondary comment for the user
        self.sub_title_label.grid(column = 1, row = 1, pady = 5) #grid set below opening welcome label
        
        self.search_entry = ttk.Entry(master = self.window) 
        self.search_entry.grid(column = 1, row = 2, padx =5, pady = 5) # first entry widget set for user to type ingredients

        self.search_button = tk.Button(master = self.window, 
                    text = "Show me recipes! ", 
                    highlightbackground = HL_COLOUR,
                    command = self.__button_func)#button function to generate recipe containing user-defined ingredients
        self.search_button.grid(column = 1, row = 3, padx = 5)

        self.rand_button = tk.Button(master = self.window,
                                     text = "Or just give me a random recipe",
                                     highlightbackground= HL_COLOUR,
                                     command = self.__rand_button) #random recipe command button
        self.rand_button.grid(column = 1, row = 4, pady = 2) #set via grid to be below main function button

        self.label_ingredients = ttk.Label(master = self.window, 
                                           text = "Awaiting Ingredients", 
                                           background= HL_COLOUR) #label widget - will change to report user defined ingredients
        self.label_ingredients.grid(column = 1, row = 5, pady = 2)

        self.text_widget = tk.Text(self.window, 
                                   bg = "#C1D0B5", 
                                   wrap= WORD, #wraps the words in the text box
                                   font = 'Calibri')#initialising text box using tk.Text widget, setting bg colour. 
        self.text_widget.grid(column = 1, row = 6, pady = 2, padx = 2)

    def recipe_text(self, input_text):
        """
        This function inserts text (a called recipe) into tkinter text widget under normal conditions 
        when the user inputs ingredients into the GUI.
        """
        self.text_widget.delete(1.0, tk.END) # text widget function calls the delete function. Deletes text from line 1, character 0 to the end
        self.text_widget.insert(tk.END, input_text) #calls the insert function which inserts the text in 'input_text'.

    def no_ingredients_text(self):
        """
        This function inserts a friendly error message into tkinter text widget when
        the user does not submit any ingredients.
        """
        no_ingredients_text = "Silly, you can't eat nothing. Go buy something!"
        self.text_widget.delete(1.0, tk.END) #deletes existing text
        self.text_widget.insert(tk.END, no_ingredients_text) #inserts the friendly error message to the text box

    def __button_func(self):
        """
        The button function to process the user's input ingredients. 
        """
        entry_text = self.search_entry.get() #get function is called on the search entry text widget
        self.label_ingredients.config(text=entry_text) #the label ingredients widget is updated to reflect the entry text
        user_ingredients = entry_text.split(',') #user ingredients is a list of the user defined ingredients as obtained via the entry_text above, comma seperated
        if user_ingredients != ['']:
            self.__user_input_ingredients(user_ingredients)#if the user enters at least one ingredient, the __user_input_ingredients() method is called.
            #this method will process the users ingredients as described.
        else:
            self.no_ingredients_text() #if the user has entered nothing, return the friendly error message
    
    def __rand_button(self):
        """
        The random button function - generates a random recipe from the data set.
        """
        recipes = self.__load_dataset() #the load_dataset method is called and assigned to 'recipes'
        random_recipe = random.choice(recipes) #using the random library, the choice function takes the recipes list and randomly returns a recipe from this list
        self.print_recipes([random_recipe]) # the random recipe selected is used as an argument in the call for the print_recipes() method. 
        #this will print the random recipe in the GUI. 

    
    def __user_input_ingredients(self, ingredients):
        """
        Function to process the user's input ingredients
        """
        recipes = self.__load_dataset() #the load_dataset method is called and the resulting recipes are assigned to 'recipes'
        matching_recipes = self.__ingredient_to_recipe(ingredients, recipes) #a call to the __ingredients_to_recipe method, passing the ingredients list and recipe
        #this method will match the users input ingredients to ingredients in the recipes dataset and return a list of matching recipes.
        self.print_recipes(matching_recipes) # the print_recipes method is called, passing matching recipes as an argument. 

    def __ingredient_to_recipe(self, user_ingredients, recipe_list):
        """
        Matches user input ingredients to the recipes available in the dataset
        done by iterating through the dataset and checking if each ingredient in list 
        is a subset of the user's list.
        """
        possible_recipes = [] #initialises list to store recipes that match the user's input ingredients
        recipe_rankings = [] #initialises list to store the ranking of recipes based on their compatability with the user's input ingredients
        index = 0  #initialising index tracker to keep track of each recipe in recipe list
        for recipe in recipe_list:
            recipe_ingredients, pic_link, instructions, title = recipe.values() #unpacks the value of each recipe in recipe list into seperate variables
            #each recipe in recipe_list has a list of ingredients, a picture link, instructions and a title in order.
            recipe_score = 0 #initialises recipe score, used to keep track of the score of each recipe based on the num of ingredients it matches with user's input.
            includes = [] #initialises list which will store the ingredients included in the recipe that match the user's input ingredients
            for ingredient in recipe_ingredients: # for each ingredient in each recipe's ingredients
                for user_ingredient in user_ingredients: #for each user defined ingredient
                    if user_ingredient in ingredient: #checks to see if each user defined ingredient is in the recipe ingredient
                        recipe_score = recipe_score + 1 #if the above is true, the recipe score increases by 1. 
                        if user_ingredient not in includes: #if the user's ingredient is not already in includes, it is added to the list
                            includes.append(user_ingredient) 

            if recipe_score > 0: #if the recipe score is greater than 0, meaning if there is at least 1 match between ingredients
                recipe_rankings.append([recipe_score, includes, index]) #then the recipe's score, the ingredients that match, and the recipe index are added to the list
            index = index + 1 #the index is incremented to keep track of the next recipe's index.

        sorted_recipe_rankings = sorted(recipe_rankings, reverse=True, key=lambda x: x[0])
        # key is a lambda function that sorts the recipe rankings on the 0th index (the first index). 
        # The recipe rankings list is sorted in descending order so that the the recipes with the hightest ranking (most matches)
        # are sorted first in the list

        i = 0 #initialising the index to keep track of the while loop 
        max_recipes = 100 # setting a number of maximum recipes that will show up for the user. This is needed due to the high volume of recipes.
        while i < len(sorted_recipe_rankings) and len(possible_recipes) < max_recipes:
            #the while loop iterates through the sorted recipe rankings , checking that the length of possible recipes is less than a max num of recipes
            #if this condition is met, the recipe corresponding to the current iteration's index in recipe_list is appended to possible recipes.
            possible_recipes.append(recipe_list[sorted_recipe_rankings[i][2]])
            i = i +1 
        
        return possible_recipes #possible recipes will contain the recipes that match the user's input ingredients, to a max of 100 recipes
    
    def __load_dataset(self):
        """
        Function to load existing data set sourced 
        from https://github.com/rtlee9/recipe-box
        """
        with open('recipes_raw_nosource_epi.json', 'r') as file:
            recipes = json.load(file) #loading the json file with json.load() function.
        recipe_list = [] #initialising recipe_list
        for _, recipe in recipes.items(): #the nature of the dataset means there are two levels of dicionary. The first level is denoted by _, indicating it is not to be used. 
            recipe_list.append(recipe) #for each recipe in the recipes file (dictionary), append this to a list of recipes.
        return recipe_list #returning the recipe_list
    
    def print_recipes(self, possible_recipes):
        """
        This function formats the list of recipes based off all possible recipes to return. 
        The recipes are seperated by '-' to signify when a new recipe begins.
        """
        total_text = f"{len(possible_recipes)} possible recipes found!\n {'-'*50} \n" #tells the user how many possible recipes are displayed
        for recipe in possible_recipes:
            total_text = total_text + recipe['title']+ "\n"
            total_text = total_text + 'Ingredients:\n' + '\n'.join(recipe['ingredients'])+ "\n"
            total_text = total_text + 'Instructions:\n'+ recipe['instructions']+ "\n"
            total_text = total_text + "-"*50 +"\n" #formatting the text to include the title, ingredients and instructions. 

        self.recipe_text(total_text) #passing the text to the recipe_text method where the text is diplayed in the GUI

#the mainloop function is called on the RecipeApp() class to display the tkinter GUI. 
app = RecipeApp()
app.window.mainloop()


    
