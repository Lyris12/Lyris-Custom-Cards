--
local id,ref=GIR()
function ref.start(c)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(ref.spcon)
	e2:SetCost(ref.spcost)
	e2:SetTarget(ref.sptg)
	e2:SetOperation(ref.spop)
	c:RegisterEffect(e2)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(70095154)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(id)
	c:RegisterEffect(e0)
end
function ref.filter(c)
	return c:IsSetCard(0x46) and c:IsAbleToHand()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function ref.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function ref.spfilter(c,e,tp)
	return c:IsSetCard(0x93) and c:IsRace(RACE_MACHINE) and c:IsLevelBelow(4) and c:IsSummonable(true,nil)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_DECK)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
