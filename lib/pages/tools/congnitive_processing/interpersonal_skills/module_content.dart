import 'skill_models.dart';

class InterpersonalSkillsData {
  static const List<SkillModule> modules = [
    // MODULE 1: BOUNDARIES
    SkillModule(
      type: SkillModuleType.boundaries,
      title: 'Boundaries',
      description: 'Understanding personal limits and learning how to say no safely.',
      cards: [
        LearningCard(
          title: 'What Are Boundaries?',
          description: 'Boundaries are the limits we set to protect our wellbeing, time, energy, and values. Healthy boundaries help us feel safe while allowing us to build respectful relationships with others.',
        ),
        LearningCard(
          title: 'What Boundaries Are Not',
          description: 'Setting a boundary is not being selfish or unkind. A boundary is about communicating what you are comfortable with, it is not about controlling another person\'s behaviour.',
        ),
        LearningCard(
          title: 'Why Boundaries Matter',
          description: 'People living with Complex PTSD often experience difficulties saying "no", fear disappointing others, or place other people\'s needs before their own. Learning healthy boundaries can reduce emotional exhaustion, resentment, and people-pleasing behaviours.',
        ),
        LearningCard(
          title: 'Healthy Boundary Examples',
          description: 'Respectful boundaries protect both yourself and your relationships. Healthy examples include:',
          bulletPoints: [
            '"I need some time to think before I answer."',
            '"I\'m not comfortable discussing that."',
            '"I can\'t help today."',
          ],
        ),
        LearningCard(
          title: 'Remember',
          description: 'People may not always like your boundaries, but healthy people can learn to respect them. You are allowed to protect your emotional wellbeing without feeling guilty.',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          questionText: 'Your friend asks you to lend them money, but you don\'t feel comfortable doing so. What is the healthiest response?',
          options: [
            'Lend the money because you don\'t want to disappoint them.',
            'Politely explain that you\'re not comfortable lending money.',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy boundaries allow you to say no respectfully. Caring about someone does not mean you must ignore your own comfort or financial limits.',
        ),
        QuizQuestion(
          questionText: 'Someone asks you to stay late to help with work, but you already have plans. What would be the healthiest response?',
          options: [
            'Cancel your plans because saying no feels rude.',
            'Explain that you already have commitments and cannot stay.',
          ],
          correctOptionIndex: 1,
          rationale: 'Your time is valuable. Setting limits respectfully helps prevent burnout and allows you to care for your own wellbeing.',
        ),
        QuizQuestion(
          questionText: 'Which statement represents a healthy boundary?',
          options: [
            '"I need some time to think before I answer."',
            '"I\'ll agree now, even though I\'m uncomfortable."',
          ],
          correctOptionIndex: 0,
          rationale: 'Giving yourself time before making a decision helps you respond thoughtfully instead of reacting out of pressure or guilt.',
        ),
        QuizQuestion(
          questionText: 'Someone becomes upset after you say no to their request. What is the healthiest way to think about the situation?',
          options: [
            'Their feelings mean I should change my answer.',
            'They are allowed to feel disappointed, and I am still allowed to keep my boundary.',
          ],
          correctOptionIndex: 1,
          rationale: 'You can care about another person\'s emotions without taking responsibility for fixing them. Healthy relationships respect both people\'s needs.',
        ),
        QuizQuestion(
          questionText: 'Your family member asks personal questions that you do not want to answer. What is the healthiest response?',
          options: [
            'Answer anyway to avoid conflict.',
            'Say that you are not comfortable discussing the topic.',
          ],
          correctOptionIndex: 1,
          rationale: 'Privacy is a healthy boundary. You are not required to share personal information simply because someone asks.',
        ),
        QuizQuestion(
          questionText: 'Which of the following is NOT a healthy boundary?',
          options: [
            '"I\'m not available this weekend."',
            '"You are never allowed to see your friends again."',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy boundaries describe your own limits. Trying to control another person\'s behaviour is not a boundary.',
        ),
        QuizQuestion(
          questionText: 'A colleague frequently interrupts your lunch break to ask for help. What would be the healthiest response?',
          options: [
            'Continue helping every day, even if you never get a break.',
            'Politely explain that you need your lunch break and can help afterwards.',
          ],
          correctOptionIndex: 1,
          rationale: 'Protecting time for rest is an important form of self-care. Setting clear expectations can improve both wellbeing and communication.',
        ),
        QuizQuestion(
          questionText: 'Someone says, "If you really cared about me, you would do this." What should you remember?',
          options: [
            'Caring about someone does not mean saying yes to everything.',
            'If they are upset, I must do what they ask.',
          ],
          correctOptionIndex: 0,
          rationale: 'Healthy relationships involve respect and choice, not guilt or emotional pressure. It is possible to care about someone while maintaining your own boundaries.',
        ),
        QuizQuestion(
          questionText: 'Which response is the most assertive?',
          options: [
            '"I understand why you\'re asking, but I can\'t do that today."',
            '"Fine... I guess I\'ll do it."',
          ],
          correctOptionIndex: 0,
          rationale: 'Assertive communication is honest, respectful, and clear. It allows you to express your needs without becoming aggressive or ignoring yourself.',
        ),
        QuizQuestion(
          questionText: 'After setting a healthy boundary, you begin feeling guilty. What is the healthiest reminder?',
          options: [
            'Feeling guilty means I must have done something wrong.',
            'Feeling guilty can be a normal response, especially if setting boundaries is new, but it does not mean the boundary was wrong.',
          ],
          correctOptionIndex: 1,
          rationale: 'Many people, especially those who have experienced trauma or people-pleasing patterns, feel uncomfortable when first setting boundaries. Like any new skill, boundary-setting becomes easier with practice.',
        ),
      ],
      completionReflection: 'Setting boundaries is not about controlling other people, it is about communicating what you need to feel safe, respected, and emotionally well. Healthy boundaries can feel uncomfortable at first, especially if you are used to putting other people\'s needs before your own.\n\nRemember that saying "no" does not make you selfish or unkind. You are allowed to protect your time, energy, and emotional wellbeing. People may not always agree with your boundaries, but healthy relationships are built on mutual respect rather than obligation.\n\nLearning to set boundaries is a skill that develops through practice. Every small step is part of building greater confidence and self-respect.',
    ),

    // MODULE 2: RECOGNISING UNHEALTHY RELATIONSHIPS
    SkillModule(
      type: SkillModuleType.unhealthyRelationships,
      title: 'Recognising Unhealthy Relationships',
      description: 'Identifying common unhealthy relationship patterns like manipulation or gaslighting.',
      cards: [
        LearningCard(
          title: 'Healthy vs Unhealthy Relationships',
          description: 'Healthy relationships are built on trust, respect, communication, and mutual support. Unhealthy relationships often involve fear, control, manipulation, or repeated disrespect.',
        ),
        LearningCard(
          title: 'Common Warning Signs',
          description: 'One behaviour alone does not always define a relationship, but repeated patterns deserve attention. Some unhealthy behaviours include:',
          bulletPoints: [
            'Gaslighting',
            'Guilt-tripping',
            'Manipulation',
            'Love bombing',
            'Excessive criticism',
            'Ignoring your boundaries',
          ],
        ),
        LearningCard(
          title: 'Gaslighting',
          description: 'Gaslighting occurs when someone repeatedly causes you to question your own memories, feelings, or perception of reality. Over time, this can reduce confidence in your own judgement.',
          bulletPoints: [
            'Example: "That never happened. You\'re imagining things."',
          ],
        ),
        LearningCard(
          title: 'Guilt and Manipulation',
          description: 'Healthy people may feel disappointed, but manipulation tries to make you responsible for another person\'s emotions. Healthy relationships allow both people to express needs without using guilt.',
          bulletPoints: [
            'Example: "If you really cared about me, you would do this."',
          ],
        ),
        LearningCard(
          title: 'Remember',
          description: 'You deserve relationships where you feel respected, listened to, and emotionally safe. Learning to recognise unhealthy patterns is the first step toward building healthier connections.',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          questionText: 'You tell a friend that you don\'t want to discuss a painful memory. They reply: "I understand. We can talk about something else." What does this response demonstrate?',
          options: [
            'Emotional manipulation',
            'Respect for your boundary',
            'Passive aggression',
            'Avoidance',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy relationships respect personal boundaries without guilt or pressure. A supportive person understands that you have the right to decide what you are comfortable sharing.',
        ),
        QuizQuestion(
          questionText: 'You decline an invitation because you\'re exhausted. The other person replies: "Wow... I guess I just don\'t matter to you." What pattern does this most closely resemble?',
          options: [
            'Healthy communication',
            'Guilt-tripping',
            'Constructive feedback',
            'Conflict resolution',
          ],
          correctOptionIndex: 1,
          rationale: 'Guilt-tripping attempts to make someone feel responsible for another person\'s emotions in order to influence their behaviour. Healthy communication expresses disappointment without blaming or shaming.',
        ),
        QuizQuestion(
          questionText: 'After someone says something hurtful, you explain that it upset you. They respond: "You\'re imagining things. I never said that." Which unhealthy pattern may this indicate?',
          options: [
            'Gaslighting',
            'Healthy reassurance',
            'Assertive communication',
            'Emotional validation',
          ],
          correctOptionIndex: 0,
          rationale: 'Gaslighting involves denying or distorting another person\'s reality, causing them to question their own memory, perception, or judgement.',
        ),
        QuizQuestion(
          questionText: 'Two friends disagree about an important topic. One says: "I still respect your opinion even though I disagree." What does this demonstrate?',
          options: [
            'Emotional manipulation',
            'Healthy disagreement',
            'Passive aggression',
            'People pleasing',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy relationships allow disagreements without attacking the other person\'s character or worth. Respect can exist even when opinions differ.',
        ),
        QuizQuestion(
          questionText: 'Someone regularly says things like: "You always ruin everything." "You can never do anything right." What pattern is most concerning?',
          options: [
            'Constructive feedback',
            'Excessive criticism',
            'Honest communication',
            'Encouragement',
          ],
          correctOptionIndex: 1,
          rationale: 'Constructive feedback focuses on behaviours and solutions. Excessive criticism attacks a person\'s identity and can gradually damage self-esteem.',
        ),
        QuizQuestion(
          questionText: 'Someone accidentally hurts your feelings. After you tell them, they reply: "I\'m sorry. I didn\'t realise that affected you. I\'ll be more careful next time." This response is an example of:',
          options: [
            'Healthy accountability',
            'Manipulation',
            'Avoidance',
            'Defensiveness',
          ],
          correctOptionIndex: 0,
          rationale: 'Healthy relationships involve taking responsibility for mistakes, acknowledging another person\'s feelings, and making genuine efforts to improve.',
        ),
        QuizQuestion(
          questionText: 'You have only known someone for three days. They already say: "You\'re the only person who understands me." "We\'ll be together forever." "I need you all the time." Which pattern could this suggest?',
          options: [
            'Healthy attachment',
            'Love bombing',
            'Secure communication',
            'Normal friendship',
          ],
          correctOptionIndex: 1,
          rationale: 'Love bombing involves overwhelming someone with excessive affection or attention very early in a relationship. While affection itself is not unhealthy, unusually intense behaviour can sometimes be used to create emotional dependence.',
        ),
        QuizQuestion(
          questionText: 'You constantly worry about saying the "wrong thing" because someone often becomes angry or upset unexpectedly. How might this situation affect you?',
          options: [
            'It encourages healthy communication.',
            'It may create anxiety and emotional hypervigilance.',
            'It improves trust.',
            'It strengthens boundaries.',
          ],
          correctOptionIndex: 1,
          rationale: 'Feeling like you must constantly monitor your words or behaviour to avoid another person\'s reactions can create chronic stress and emotional insecurity.',
        ),
        QuizQuestion(
          questionText: 'Which statement best reflects a healthy relationship?',
          options: [
            'One person\'s needs are always more important.',
            'Both people respect each other\'s thoughts, feelings, and boundaries.',
            'Conflict should never happen.',
            'You should avoid expressing difficult emotions.',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy relationships involve mutual respect, open communication, and recognising that both people\'s needs and boundaries matter.',
        ),
        QuizQuestion(
          questionText: 'A conversation leaves you feeling anxious, guilty, and emotionally drained every time, even though you cannot explain exactly why. What is the healthiest first step?',
          options: [
            'Ignore your feelings.',
            'Assume you are overreacting.',
            'Pause, reflect on the interaction, and consider whether your boundaries were respected.',
            'Immediately end the relationship.',
          ],
          correctOptionIndex: 2,
          rationale: 'Your emotional reactions can provide useful information. Feeling uncomfortable does not automatically mean someone is abusive, but it can be a signal to reflect on the interaction, consider your boundaries, and seek support if needed.',
        ),
      ],
      completionReflection: 'Healthy relationships are not perfect, they include disagreements, mistakes, and difficult conversations. What matters most is whether both people respect each other\'s feelings, communicate honestly, and take responsibility for their actions.\n\nIf some of these situations feel familiar, remember that recognising unhealthy patterns is a skill that develops over time. You don\'t need to have all the answers today.',
    ),


    // MODULE 3: ASSERTIVE COMMUNICATION
    SkillModule(
      type: SkillModuleType.assertiveCommunication,
      title: 'Assertive Communication',
      description: 'Learning how to express needs respectfully and handle conflicts.',
      cards: [
        LearningCard(
          title: 'What Is Assertive Communication?',
          description: 'Assertive communication means expressing your thoughts, feelings, and needs honestly while still respecting other people. It is different from being passive or aggressive.',
        ),
        LearningCard(
          title: 'Three Communication Styles',
          description: 'Understanding our baseline communication defaults helps us build insight:',
          bulletPoints: [
            'Passive: You avoid expressing your needs.',
            'Aggressive: You express your needs while ignoring other people\'s feelings.',
            'Assertive: You communicate respectfully while protecting your own needs.',
          ],
        ),
        LearningCard(
          title: 'Assertive Language',
          description: 'Using calm and clear language often leads to healthier conversations. Helpful phrases include:',
          bulletPoints: [
            '"I need some time to think."',
            '"I\'m not comfortable with that."',
            '"I understand your point, but I see it differently."',
          ],
        ),
        LearningCard(
          title: 'Handling Conflict',
          description: 'Disagreements are a normal part of relationships. The goal is not to avoid conflict but to communicate respectfully, listen actively, and work towards solutions without attacking yourself or others.',
        ),
        LearningCard(
          title: 'Remember',
          description: 'Your needs, opinions, and feelings are valid. Practising assertive communication takes time, and small steps can gradually build confidence in everyday interactions.',
        ),
      ],
      quizQuestions: [
        QuizQuestion(
          questionText: 'Your friend says: "I think you should just drop your course and try something easier." What is the most assertive response?',
          options: [
            '"Yeah maybe you\'re right, I\'ll think about it."',
            '"Why would you say something like that? That\'s annoying."',
            '"I understand your concern, but I\'ve made my decision to continue."',
          ],
          correctOptionIndex: 2,
          rationale: 'Assertive communication involves respecting yourself while not attacking the other person. This response acknowledges the friend but maintains your boundary.',
        ),
        QuizQuestion(
          questionText: 'A colleague asks you to cover their shift last minute, but you already have plans.',
          options: [
            '"Sure, I guess I can cancel my plans."',
            '"No, I can\'t do that. Please ask someone else."',
            '"You always do this to me, I\'m tired of it."',
          ],
          correctOptionIndex: 1,
          rationale: 'This response is clear, respectful, and firm. It avoids over-explaining or emotional escalation.',
        ),
        QuizQuestion(
          questionText: 'You feel overwhelmed with group work tasks.',
          options: [
            '"It\'s fine, I\'ll just do everything myself."',
            '"You people are not helping at all."',
            '"I\'m feeling overloaded. Can we redistribute the tasks?"',
          ],
          correctOptionIndex: 2,
          rationale: 'Assertiveness includes expressing your emotional state and directly requesting a collaborative solution.',
        ),
        QuizQuestion(
          questionText: 'A teammate says: "You\'re really disorganised and slowing us down."',
          options: [
            '"I\'m sorry, I\'m useless."',
            '"That\'s not true, you\'re the problem."',
            '"I hear your concern. Let\'s look at how I can improve my organisation."',
          ],
          correctOptionIndex: 2,
          rationale: 'This option stays grounded, avoids falling into shame or counter-aggression, and focuses productively on improvement.',
        ),
        QuizQuestion(
          questionText: 'A friend keeps calling you late at night.',
          options: [
            '"It\'s okay, I don\'t mind."',
            '"Please stop calling me at night. I need rest."',
            '"You\'re so disrespectful for calling me all the time."',
          ],
          correctOptionIndex: 1,
          rationale: 'A clear boundary combined with a simple, honest statement is the healthiest way to manage personal limits.',
        ),
        QuizQuestion(
          questionText: 'You disagree with a group decision.',
          options: [
            '"Whatever, do what you want."',
            '"I don\'t agree, but I understand why others think this way. Here\'s my view…"',
            '"This is stupid, you\'re all wrong."',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy disagreement balances mutual respect for the group\'s context with crisp clarity about your own position.',
        ),
        QuizQuestion(
          questionText: 'You are struggling with workload.',
          options: [
            '"I should be able to handle it myself."',
            '"Can someone help me with part of this task? I\'m at capacity."',
            '"Nobody here helps me anyway."',
          ],
          correctOptionIndex: 1,
          rationale: 'Assertiveness includes asking for support directly without leaning on guilt, submissiveness, or blame.',
        ),
        QuizQuestion(
          questionText: 'Someone says: "If you were a good friend, you would do this for me."',
          options: [
            '"Okay, I\'ll do it then."',
            '"I don\'t like being pressured like this. I can\'t do it."',
            '"Fine, but don\'t talk to me again."',
          ],
          correctOptionIndex: 1,
          rationale: 'This response immediately recognises emotional manipulation and maintains your boundary calmly.',
        ),
        QuizQuestion(
          questionText: 'You feel hurt by a friend\'s comment.',
          options: [
            '"You\'re a bad friend."',
            '"I didn\'t like that comment. It made me feel hurt."',
            '"I don\'t care about anything anymore."',
          ],
          correctOptionIndex: 1,
          rationale: 'Healthy emotional expression safely avoids global blame and exaggeration while remaining completely honest.',
        ),
        QuizQuestion(
          questionText: 'After an argument, you want to resolve things.',
          options: [
            '"Forget it, I don\'t care anymore."',
            '"You need to apologise first."',
            '"Can we talk about what happened? I want to understand both sides."',
          ],
          correctOptionIndex: 2,
          rationale: 'Assertive communication actively supports mutual resolution, rather than relying on total avoidance or control tactics.',
        ),
      ],
      completionReflection: 'Assertive communication is a skill that develops with practice. It is normal for it to feel uncomfortable at first, especially if past experiences taught you that speaking up was unsafe. Every time you express your needs honestly and respectfully, you are reinforcing the belief that your thoughts, feelings, and boundaries matter.\n\nYou do not need to communicate perfectly. Small, consistent steps toward clearer and kinder communication can gradually strengthen your confidence and support healthier relationships.',
    ),
  ];
}