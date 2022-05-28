#!/usr/bin/env python
# coding: utf-8

# In[1]:


# This Python 3 environment comes with many helpful analytics libraries installed
# It is defined by the kaggle/python Docker image: https://github.com/kaggle/docker-python
# For example, here's several helpful packages to load

import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)

# Input data files are available in the read-only "../input/" directory
# For example, running this (by clicking run or pressing Shift+Enter) will list all files under the input directory

import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))

# You can write up to 20GB to the current directory (/kaggle/working/) that gets preserved as output when you create a version using "Save & Run All" 
# You can also write temporary files to /kaggle/temp/, but they won't be saved outside of the current session


# In[6]:


movies = pd.read_csv('tmdb_5000_movies.csv')
credits = pd.read_csv('tmdb_5000_credits.csv')


# In[7]:


movies.head(2)


# In[8]:


movies.shape


# In[9]:


credits.head()


# In[10]:


movies = movies.merge(credits,on='title')


# In[11]:


movies.head()
# budget
# homepage
# id
# original_language
# original_title
# popularity
# production_comapny
# production_countries
# release-date(not sure)


# In[12]:


movies = movies[['movie_id','title','overview','genres','keywords','cast','crew']]


# In[13]:


movies.head()


# In[14]:


import ast


# In[15]:


def convert(text):
    L = []
    for i in ast.literal_eval(text):
        L.append(i['name']) 
    return L 


# In[16]:


movies.dropna(inplace=True)


# In[17]:


movies['genres'] = movies['genres'].apply(convert)
movies.head()


# In[18]:


movies['keywords'] = movies['keywords'].apply(convert)
movies.head()


# In[19]:


import ast
ast.literal_eval('[{"id": 28, "name": "Action"}, {"id": 12, "name": "Adventure"}, {"id": 14, "name": "Fantasy"}, {"id": 878, "name": "Science Fiction"}]')


# In[20]:


def convert3(text):
    L = []
    counter = 0
    for i in ast.literal_eval(text):
        if counter < 3:
            L.append(i['name'])
        counter+=1
    return L 


# In[21]:


movies['cast'] = movies['cast'].apply(convert)
movies.head()


# In[22]:


def fetch_director(text):
    L = []
    for i in ast.literal_eval(text):
        if i['job'] == 'Director':
            L.append(i['name'])
    return L 


# In[23]:


movies['crew'] = movies['crew'].apply(fetch_director)


# In[24]:


#movies['overview'] = movies['overview'].apply(lambda x:x.split())
movies.sample(5)


# In[25]:


def collapse(L):
    L1 = []
    for i in L:
        L1.append(i.replace(" ",""))
    return L1


# In[26]:


movies['cast'] = movies['cast'].apply(collapse)
movies['crew'] = movies['crew'].apply(collapse)
movies['genres'] = movies['genres'].apply(collapse)
movies['keywords'] = movies['keywords'].apply(collapse)


# In[27]:


movies.head()


# In[28]:


movies['overview'] = movies['overview'].apply(lambda x:x.split())


# In[29]:


movies['tags'] = movies['overview'] + movies['genres'] + movies['keywords'] + movies['cast'] + movies['crew']


# In[30]:


new = movies.drop(columns=['overview','genres','keywords','cast','crew'])
#new.head()


# In[31]:


new['tags'] = new['tags'].apply(lambda x: " ".join(x))
new.head()


# In[32]:


from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features=5000,stop_words='english')
    


# In[33]:


vector = cv.fit_transform(new['tags']).toarray()


# In[34]:


vector.shape


# In[35]:


from sklearn.metrics.pairwise import cosine_similarity


# In[36]:


similarity = cosine_similarity(vector)


# In[37]:


similarity


# In[38]:


new[new['title'] == 'The Lego Movie'].index[0]


# In[39]:


def recommend(movie):
    
    index = new[new['title'] == movie].index[0]
    print(index)
    distances = sorted(list(enumerate(similarity[index])),reverse=True,key = lambda x: x[1])
    # print(distances)
    for i in distances[1:6]:
        print(new.iloc[i[0]].title)
    return index


# In[40]:


# recommend('Gandhi')


# In[41]:





# In[42]:





# In[ ]:




