local Dialogue = {}
Dialogue.__index = Dialogue

function Dialogue:new(name, debugMode)
    local self = setmetatable({}, Dialogue)
    self.name = name

    if debugMode then 
        self.text = {
            "Howdy.",
            "CHOICE"
        }
        self.spokenToText = {
            "Good day."
        }
        self.caughtText = {
            "You caught me!"
        }
        self.accusedText = {
            "I'm innocent! You got the wrong person!",
        }
        self.uncooperative = {
            "I don't want to talk to you anymore.",
        }
    elseif name == "Crimson Reddington" then
    	self.text = {
    		"Bold of you to approach me with such a humble cut, peasant.",
    		"I do hope you do your job quickly so I can get back to my tea and feminine company",
        	"CHOICE",
        	"Now go, before I catch one of those plagues you people are so fond of.",
        	"Street rat.",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    elseif name == "Aqua Bloomberg" then
    	self.text = {
    		"Ah, hello detective.",
    		"The innocent die and the guilty prosper, I suppose.",
        	"CHOICE",
        	"I do hope this information proves useful, detective.",
        	"Au revoir.",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    elseif name == "Lief Greenhand" then
    	self.text = {
    		"Hi! I'm Lief! Let me know if I can help!",
    		"You sure have a sparkle in your eye for someone investigating a murder case, detective. How peculiar!",
        	"CHOICE",
        	"Oh! I get it! You're doing detective stuff with these clues, aren't you!",
        	"Wait, did someone take my biscuit?",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    elseif name == "Dick Goldmember" then
    	self.text = {
    		"Listen here, bumpkin.",
    		"Now, ya might think yer cool just cuz you're some kinda badass harbinger of justice, but yer nothing compared to me!",
    		"Oh, and stay away from the ladies tonight, will ya?",
        	"CHOICE",
        	"It's not like I want to aid in your investigation or anything.",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    elseif name == "Bob Gray" then
    	self.text = {
    		"Hmm. Hey.",
    		"I'm Bob.",
    		"Don't call me Bob though.",
    		"So, what do you want?",
        	"CHOICE",
        	"Move along, now.",
        	"Can't you see I'm busy?",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    elseif name == "Violet Purpov" then
    	self.text = {
    		"Hey there, cutie.",
    		"What's a fine piece of man like yourself doing in a place like this?",
        	"CHOICE",
        	"I see you're a man that sticks to his job.",
        	"Come back if you want to sneak out to the garden.",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    elseif name == "Wilson White" then
    	self.text = {
    		"Uh, hey, uh, hehe...",
    		"What brings you over here, detective?",
    		"N-not that I have a problem with that...",
        	"CHOICE",
        	"That's all I know! I swear!",
        	"*Incoherent murmuring*",
    	}
        self.spokenToText = {}
        self.caughtText = {}
        self.accusedText = {}
    end

    return self
end
return Dialogue
