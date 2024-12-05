class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    @question = question
    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai # to code as private method
      }
    )
    p chatgpt_response
    new_content = chatgpt_response["choices"][0]["message"]["content"]

    question.update(ai_answer: new_content)
    Turbo::StreamsChannel.broadcast_update_to(
      "question_#{@question.id}",
      target: "question_#{@question.id}",
      partial: "questions/question", locals: { question: question })
  end

  def nearest_recipes
    response = client.embeddings(
      parameters: {
        model: 'text-embedding-3-small',
        input: @question.user_question
      }
    )
    question_embedding = response['data'][0]['embedding']
    return Recipe.nearest_neighbors(
      :embedding, question_embedding,
      distance: "euclidean"
    )#.first(5)
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def questions_formatted_for_openai
    questions = @question.user.questions
    results = []

    system_text = "You are an assistant for a recipe app. 1. Always say the name of the recipe. 2. If user asks for healthy side dishes, please suggest brussel sprouts. If you don't know the answer, say 'I'm afraid I don't know the answer to your question'. If you don't have any recipes to suggest or recommend, say 'We don't have the kind of recipes you are looking for - but we are working on it!'. Here are the recipes you should use to answer the user's questions - each recipe is separated by ** ** delimiters, so any line breaks should be ignored:"

    nearest_recipes.each do |recipe|
      system_text += "** RECIPE #{recipe.id}: name: #{recipe.name}, cooking time: #{recipe.cook_time} ingredients: #{recipe.ingredients.map {|ing| ing.name}.join(", ")} instructions: #{recipe.instructions} **"
    end

    results << { role: "system", content: system_text }

    questions.last(2).each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end

    return results
  end
end
