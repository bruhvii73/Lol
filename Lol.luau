-- This is the complete script with the quiz logic.
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local points = {}  -- Tracks player points
local retryTime = 5  -- Retry time after wrong answer
local currentQuestionIndex = 1  -- Start with first question
local maxQuestions = 4  -- Max number of questions
local quizActive = true  -- Flag to indicate if quiz is active

-- Sample questions for the quiz
local questions = {
    {question = "What is your favorite gaming console?", choices = {"A: PlayStation", "B: Xbox", "C: Nintendo Switch", "D: PC"}, correctAnswer = "A"},
    {question = "Which game is most popular?", choices = {"A: Fortnite", "B: Minecraft", "C: Roblox", "D: Call of Duty"}, correctAnswer = "B"},
    {question = "What is the best gaming genre?", choices = {"A: Action", "B: Puzzle", "C: RPG", "D: Shooter"}, correctAnswer = "C"},
    {question = "Which is the most powerful console?", choices = {"A: PlayStation 5", "B: Xbox Series X", "C: Nintendo Switch", "D: PC"}, correctAnswer = "B"}
}

-- Function to create GUI for quiz
local function createQuizGUI()
    -- Remove old GUI if exists
    if playerGui:FindFirstChild("QuizGUI") then
        playerGui.QuizGUI:Destroy()
    end

    -- Create new ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QuizGUI"
    screenGui.Parent = playerGui

    -- Create question label
    local questionLabel = Instance.new("TextLabel")
    questionLabel.Text = questions[currentQuestionIndex].question
    questionLabel.Size = UDim2.new(0, 400, 0, 50)
    questionLabel.Position = UDim2.new(0.5, -200, 0.2, 0)
    questionLabel.Parent = screenGui

    -- Create choice buttons
    local buttonStartY = 0.4
    for i, choice in ipairs(questions[currentQuestionIndex].choices) do
        local button = Instance.new("TextButton")
        button.Text = choice
        button.Size = UDim2.new(0, 200, 0, 50)
        button.Position = UDim2.new(0.5, -100, buttonStartY, 0)
        button.Parent = screenGui
        button.MouseButton1Click:Connect(function()
            checkAnswer(i)  -- Check answer when button is clicked
        end)

        buttonStartY = buttonStartY + 0.1
    end

    -- Create stop button
    local stopButton = Instance.new("TextButton")
    stopButton.Text = "Stop Quiz"
    stopButton.Size = UDim2.new(0, 200, 0, 50)
    stopButton.Position = UDim2.new(0.5, -100, 0.8, 0)
    stopButton.Parent = screenGui

    stopButton.MouseButton1Click:Connect(function()
        stopQuiz()  -- Stop the quiz when button is clicked
    end)
end

-- Function to check the player's answer
local function checkAnswer(choiceIndex)
    local correctChoice = questions[currentQuestionIndex].correctAnswer
    local playerChoice = string.char(64 + choiceIndex)  -- Convert choiceIndex (1-4) to A, B, C, D

    if playerChoice == correctChoice then
        points[player.Name] = (points[player.Name] or 0) + 1
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Correct! You earned 1 point.", "All")
    else
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Incorrect! Try again in " .. retryTime .. " seconds.", "All")
        wait(retryTime)  -- Wait for retry time
    end

    currentQuestionIndex = currentQuestionIndex + 1
    if currentQuestionIndex > maxQuestions then
        stopQuiz()  -- End the quiz after maxQuestions
    else
        createQuizGUI()  -- Load next question
    end
end

-- Function to stop the quiz
local function stopQuiz()
    quizActive = false
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Quiz has ended. Final points: " .. (points[player.Name] or 0), "All")
end

-- Start the quiz by creating the first question
createQuizGUI()
