import json
import openpyxl

#create a main function that will be run via command line
def main():
    #open the excel file
    wb = openpyxl.load_workbook('../../project-CB-Story.xlsx')
    #open the sheet
    sheet = wb['Sheet1']
    #create a dictionary to store the data
    data = {}
    index=0
    #iterate over the rows in the sheet
    for row in sheet.iter_rows(min_row=2, max_row=sheet.max_row, min_col=1, max_col=3, values_only=True):
        #extract the data from the row
        game_time, assigned_channel, story_text,sound_file_name = row
        #store the data in the dictionary
        data[index] = {
            'gameTime': game_time,
            'assignedChannel': assigned_channel,
            'text': story_text,
            'soundFileName': sound_file_name
        }
        index+=1
    #write the data to a JSON file
    with open('../../source/Story/StoryPointTest.json', 'w') as f:
        json.dump(data, f, indent=4)