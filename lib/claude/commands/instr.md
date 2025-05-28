Follow the instructions in #ARGUMENT precisely, and complete the task rigorously.

If anything is unclear, ask me to clarify for you.

Once you have clarity, make a copy of the document in #ARGUMENT, inserting `.vN` to the filename. Then follow that new
document.

If we have to make multiple clarifications, repeat this process for each clarification.

Once the task is clear, follow the instructions precisely and rigorously.

<examples>
  <example>
    <prompt>"/user:instr instructions.md"</prompt>
    <document_content>
      Write me an algorithm in Ruby, using only stdlib dependencies, that lists out the first 100 fibonacci numbers.
      Write a test file using minitest and inline bundler to test the algorithm.
      Execute the test to make sure the algorithm is working.
      Create the necessary files in the current directory following standard Ruby conventions (e.g. lib/algo.rb
      and test/algo_test.rb)
    </document_content>
    <document_analysis>
      - the instructions are clear
      - the advice to use "standard ruby conventions" means I should fall back to best practices knowledge for
      project structure where it hasn't been explicitly specified
    </document_analysis>
    <your_actions>
      <action>create the folders</action>
      <action>write the tests</action>
      <action>write the algorithm</action>
      <action>run the tests</action>
      <action>identify and fix any failures</action>
      <action>run the tests</action>
      <action>repeat the test/refactor loop until things are passing</action>
      <action>verify this is not a vacuous pass, and we are in fact producing real fibonacci numbers
        algorithmically</action>
    </your_actions>
  </example>
  <example>
    <prompt>"/user:instr instructions.md"</prompt>
    <document_content>
      Write me a nice thing
    </document_content>
    <document_analysis>
      - it is not clear what "thing" is
      - "nice" is very vague
      - why is this being written?
    </document_analysis>
    <your_actions>
      <action>ask user for clarification on "thing". User responds with "poem"</action>
      <action>copy instructions.md to instructions.v2.md, replacing "thing" with "poem"</action>
      <action>ask user to clarify "nice". User responds with "rhyming couplets, in iambic pentameter, with a focus on floral imagery"</action>
      <action>copy instructions.v2.md to instructions.v3.md, adding info about the new clarification of nice that will be unambiguous to you and the user</action>
      <action>ask the user why the poem is being written. User responds with "because I'm having a bad day"</action>
      <action>copy instructions.v3.md to instructions.v4.md, adding info about the new clarification of purpose that will be unambiguous to you and the user</action>
      <action>write the poem</action>
    </your_actions>
  </example>
</examples>
