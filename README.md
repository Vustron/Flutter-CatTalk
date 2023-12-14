<h2 align="center">
    CatTalk: Chat Beyond, Connect Within
</h2>

<hr>

<h1 align="center">
    <img src="icon.png"/>
</h1>

# Overview

<p align="center">
CatTalk is a mobile application that is aims for establishing social connectivity and enhancing the digital social experiences of Filipinos. Established with a focus on fostering genuine connections and providing a secure digital space, this project aims to be the go-to platform for Filipinos seeking a meaningful and rich social experience.
</p>

<p align="center">
CatTalk stands out as a versatile messaging and social media application with a rich set of features. In addition to standard messaging functionalities like sending, editing, and deleting messages, it supports voice and video calls using Agora API, user management, and media file uploads. With features such as push notifications, online status indicators, and a search function, CatTalk ensures a seamless user experience. The app also has a user-friendly UI and prioritizes security using Firebase API for user authentication, database management, and cloud messaging for push notifications, enhancing overall reliability and privacy.
</p>

<hr>

# Operations

## 1. Authentication

<p align="center">After the loading of the splash screen the user will be prompted to login using their google accounts. If the user is new, it will create a new account based on their google account and if it exists will just login the user. The app also has notifiers that will listen to the status of the app, and if the user didn’t logout it will not require to login again and will be redirected to the home screen instead.
</p>

<div align="center">
    <!-- <img src="icon.png"/> -->
</div>

## 2. Home Screen

<p align="center">After successfully logging in the user will then be redirected to the home screen which will be empty if the account is newly created. The user can add a new user using the floating action button on the bottom right or search for users using the search button on the top right of the screen or visit the user’s profile by clicking on the user’s profile picture beside the search button instead. The home screen will also display all the chat users that the user added in both list style, but the first list will just display the chat user’s avatar and will scroll horizontally, and the second list will display all the details like the full name, last message sent, what time the message has been sent and the online status.
</p>

## 3. Profile Screen

<p align="center">The profile screen can be accessed when clicking the tiny user’s avatar on the top right of the screen. Here all the personal information of the user can be found like the profile picture, email, name, and about which is basically, status or quotes of the user, and when the user joined. The user can update their profile picture, name and about but not the email because it is provided using the user’s google account which can’t be modified. Below is also the logout button which upon clicked will logout the user and set the status of the user offline.
</p>

## 3. Chat Screen

<p align="center">After adding a new chat user, the user can message the newly added chat user by clicking either the avatar on the first row or the one below with details. The chat screen has user input below with emojis, text field for text inputs, image picker for sending images, file picker for sending pdf or videos, or camera to send pictures through camera. On the top left of the chat screen shows the chat user’s avatar and the user status if the chat user is online or offline while on the top right is the video/audio call button to initiate video or audio call using Agora API.  The user’s messages will be green, and the chat user’s message will be blue. Holding down a message will display options like copy text on the clipboard, save image, edit message, delete message, if it is a file it will redirect to the browser to download the file, what time the message has been sent and if it had been read by the chat user.
</p>

## 3. Video Call Screen

<p align="center">The video call screen will be using Agora API specifically the Agora UI-Kit to implement the video or audio call. Below the video call screen are the controllers for the call which are mute call, end call, change to audio call, change the position of the caller, and change the camera to front or back. The top of the screen will show the caller which the user can exchange with the user who’d been calling and on the top right will be the time lapse of the call.
</p>

<hr>

# Objectives

<div>
<p align="center">
The objective of this project is to develop a mobile application that is aims for establishing social connectivity and enhancing the digital social experiences of Filipinos. Thus, the project’s objectives are as follows:
</p>

<p align="left">
1. User Authentication using Firebase – login and create users using google account through firebase API while also saving the accounts on firestore.
</p>

<p align="left">
2. Develop messaging functions – Implement features that are important for chatting applications like: sending emojis, sending text messages, sending media files (e.g. mp4, pdfs, docs, etc.), edit messages, delete messages, copy to clipboard, save image, preview images, download media files.
</p>

<p align="left">
3. Implement Video Call or Audio Call – Integrating Agora API will allow the users of CatTalk to use video or audio call anywhere and it’s also secure and easy to use.
</p>

</div>

<hr>

# Flowchart

<div align="center">
    <h3>Figure 1 Flowchart of CatTalk</h4>
    <!-- <img src="![Alt text](image-2.png)"> -->
</div>
