import pandas as pd

#data is a dataframe
data = pd.read_csv('userReviews.csv',sep=';')

#print(data.head())
#print(data[:3])
#print(data.movieName.iloc[1])

#define column names in subset
column_names = ['movieName', 'Metascore_w','Author',
                'AuthorHref', 'Date', 'Summary',
                'InteractionsYesCount', 'InteractionsTotalCount','InteractionsThumbUp', 'InteractionsThumbDown']
#copy csv values into subset
subset = pd.DataFrame(columns = column_names)

#select all reviews for the original pick which have a metascore of 7 or higher
for movie in range(len(data)):
    if data.movieName.iloc[movie] == 'the-hunger-games': #original pick
        row = data[movie:movie+1]
        subset = subset.append(row)
subset = subset[subset.Metascore_w >= 7]
#Limited the results to show only 10 authors
subset = subset.iloc[0:10, ]
#show the subset
print(subset)

#define column names for better_movies
c_names = ['Author', 'movieName', 'Metascore_w']

#create an empty dataframe with columns as specified above
better_movie = pd.DataFrame(columns = c_names)

#stating that abs_score and relative_score are integers
abs_score = []
relative_score = []

#select authors that have reviewedc original pick and where other review scores higher than original pick
#calculate absolute increase of metascore_w
#calculate relative increase of metascore_w
#put abs_score into a new column 'abs_score'
#put relative_score into a new column 'relative_score'
#double sort ascending. First by 'metascore_w' and then by 'abs_score'
for a in range(len(subset)):
    for b in range(len(data)):
        if subset.Author.iloc[a] == data.Author.iloc[b] and subset.Metascore_w.iloc[a] < data.Metascore_w.iloc[b]: 
            inc_meta = data.Metascore_w.iloc[b] - subset.Metascore_w.iloc[a] 
            rel_score = "{:.0%}".format(inc_meta / subset.Metascore_w.iloc[a])
            row = data[c_names].iloc[b]
            better_movie = better_movie.append(row)
            abs_score.append(inc_meta)
            relative_score.append(rel_score)
better_movie['abs_score'] = abs_score 
better_movie['relative_score'] = relative_score 
better_movie = better_movie.sort_values(by=['Metascore_w', 'abs_score'], ascending = False )

#Include 25 results only
better_movie = better_movie.head(25)
#show results
print(better_movie)

#Save the output file in csv in the specified directory
better_movie.to_csv(r'recom_hunger.csv', index = False, header=True)

