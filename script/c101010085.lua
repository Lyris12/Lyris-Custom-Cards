--Flame Flight - Raven
local id,ref=GIR()
function ref.start(c)
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(101010576)
	e3:SetRange(0xfe)
	c:RegisterEffect(e3)
	--fusion react
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(ref.con)
	e2:SetOperation(ref.mat)
	c:RegisterEffect(e2)
end
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function ref.mat(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsAttribute(ATTRIBUTE_FIRE) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) end
end
