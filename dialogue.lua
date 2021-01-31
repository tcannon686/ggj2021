local Dialogue = {}
Dialogue.__index = Dialogue

function Dialogue:new(name, debugMode)
    local self = setmetatable({}, Dialogue)
    self.name = name

    if debugMode then 
        self.text = {
            "I fucked your mom",
            "CHOICE"
        }
        self.spokenToText = {
            "I dont talk to bitches like you."
        }
        self.caughtText = {
            "I cant believe you got me motherfucker."
        }
        self.accusedText = {
            "...",
            ".....",
            "........",
            "where the bitches at"
        }
        self.uncooperative = {
        	"Nah bith"
        }
    elseif name == "Crimson Reddington" then
    	self.text = {
    		"Bold of you to approach me with such a humble cut, peasant.",
    		"I do hope you do your job quickly so I can get back to my tea and feminine company",
        	"CHOICE",
        	"Now go, before I catch one of those plagues you people are so fond of.",
        	"Street rat.",
    	}
        self.spokenToText = {
        	"You dare test the patience of your better?",
        	"Go away before I give you a real job.",
        	"We've already spoken, imbecile.",
        }
        self.caughtText = {
        	"And I would've gotten away with it if it weren't for that blasted detective!!"
        }
        self.accusedText = {
        	"You dare accuse a man of stature such as myself?! Wrong, fool."
        }
        self.uncooperative = {
        	"Hmph. I suppose the common rabble wouldn't recognize a gentleman of class and dignity such as myself. Go away.",
        	"Jest elsewhere.",
        	"I should have your neck for your petty insolence."
        }
    elseif name == "Aqua Bloomberg" then
    	self.text = {
    		"Ah, hello detective.",
    		"The innocent die and the guilty prosper, I suppose.",
        	"CHOICE",
        	"I do hope this information proves useful, detective.",
        	"Au revoir.",
    	}
        self.spokenToText = {
        	"Oh dear, feeling a little case of memory loss?",
        	"I've told you all I can.",
        	"What else can I say?",
        }
        self.caughtText = {
        	"You got me, I suppose. I give."
        }
        self.accusedText = {
        	"I'm appalled you would think so lowly of me. I didn't do it."
        }
        self.uncooperative = {
        	"Don't expect any favors from me dear.",
        	"I'm quite upset with you.",
        	"...",
        }
    elseif name == "Lief Greenhand" then
    	self.text = {
    		"Hi! I'm Lief! Let me know if I can help!",
    		"You sure have a sparkle in your eye for someone investigating a murder case, detective. How peculiar!",
        	"CHOICE",
        	"Oh! I get it! You're doing detective stuff with these clues, aren't you!",
        	"Wait, did someone take my biscuit?",
    	}
        self.spokenToText = {
        	"Dummy! You already asked me something!",
        	"You must not remember our conversation. That saddens me.",
        	"We already talked! Ask one of the others something.",
        }
        self.caughtText = {
        	"Hehe!!! UwU o3o Looks like u caught me xDDD MURDERMURDERMURDER"
        }
        self.accusedText = {
        	"Waah! You thought I killed them? I hate you!!!"
        }
        self.uncooperative = {
        	"I'm sooo done talking to you.",
        	"Leave! I don't wanna talk to you!",
        	"So rude, man. Just cold.",
        }
    elseif name == "Dick Goldmember" then
    	self.text = {
    		"Like, listen here, bumpkin.",
    		"Now, ya might think yer, like, cool just cuz you're, like, some kinda badass harbinger of justice, but yer nothing compared to me!",
    		"Like, stay away from the ladies tonight, will ya man?",
        	"CHOICE",
        	"It's not like I want to aid in your investigation or anything.",
    	}
        self.spokenToText = {
        	"Like, you ardy were here.",
        	"Bro, you already asked me something.",
        	"Go ask Bob something. I told you all I know."
        }
        self.caughtText = {
        	"Ok, ok, I did it bro. But only because it was totally a chad thing to do."
        }
        self.accusedText = {
        	"Hey man, I'm chillin. I didn't kill anything."
        }
        self.uncooperative = {
        	"Dude, we are not chill anymore.",
        	"Go away, man. We aren't homies.",
        	"You ruined my vibe man. My vibe! Bounce.",
        }
    elseif name == "Bob Gray" then
    	self.text = {
    		"Hmm. Hey.",
    		"I'm Bob.",
    		"Don't call me Bob.",
    		"So, what do you want?",
        	"CHOICE",
        	"Move along, now.",
        	"Can't you see I'm busy?",
    	}
        self.spokenToText = {
        	"What?",
        	"You've been here.",
        	"Solved it yet?",
        }
        self.caughtText = {
        	"Yup. It was me."
        }
        self.accusedText = {
        	"Nope."
        }
        self.uncooperative = {
        	"I'm disappointed in you.",
        	"Maybe next game.",
        	"Vacate my space."
        }
    elseif name == "Violet Purpov" then
    	self.text = {
    		"Hey there, cutie.",
    		"What's a fine piece of man like yourself doing in a place like this?",
        	"CHOICE",
        	"I see you're a man that sticks to his job.",
        	"Come back if you want to sneak out to the garden.",
    	}
        self.spokenToText = {
        	"I'm glad you're back, but I really don't know anything else.",
        	"I told you what I know, hun.",
        	"Maybe ask someone else?",
        }
        self.caughtText = {
        	"Gaah! How did you know it was me! I even tried the time-old method of seduction!"
        }
        self.accusedText = {
        	"*Sniff* How could you be so cruel? Of course it wasn't me!"
        }
        self.uncooperative = {
        	"You're rude. Leave me alone.",
        	"And here I thought detectives were gentlemen. Go somewhere else.",
        	"Arrest me if you want. I'm not talking to you, pig."
        }
    elseif name == "Wilson White" then
    	self.text = {
    		"Uh, hey, uh, hehe...",
    		"What brings you over here, detective?",
    		"N-nothing wrong here...",
        	"CHOICE",
        	"That's all I know! I swear!",
        	"*Incoherent murmuring*",
    	}
        self.spokenToText = {
        	"Eep! That's all I know, I swear!",
        	"Please no bad cop! I have a fragile appendix.",
        	"*Gulp* I told you what you wanted to know, right?",
        }
        self.caughtText = {
        	"HAH! Looks like my reverse psychology based on murder mystery stereotypes has failed! You got me."
        }
        self.accusedText = {
        	"It wasn't me! I swear it! I'm not your guy!"
        }
        self.uncooperative = {
        	"I want a lawyer!",
        	"Hey, wait, you never had solid evidence! Are you really a detective?",
        	"My feelings are still hurt after what you said about me.",
        }
    end

    return self
end
return Dialogue