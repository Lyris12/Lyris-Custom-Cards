--烈風のラーク
local id,ref=GIR()
function ref.start(c)
--search
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_TO_DECK)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,id)
	e0:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():IsReason(REASON_EFFECT+REASON_MATERIAL) end)
	e0:SetTarget(ref.tg)
	e0:SetOperation(ref.op)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	c:RegisterEffect(e1)
end
function ref.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd5d) and c:IsAbleToHand() and c:GetCode()~=id
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function ref.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd5d) and not c:IsType(TYPE_SYNCHRO)
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
