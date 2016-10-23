--Ａ・ＶＩＬＬＡＩＮ・サイバー・スペース・カイザー
function c101010413.initial_effect(c)
	aux.AddFusionProcFun2(c,c101010413.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x93),false)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c101010413.spcon)
	e0:SetOperation(c101010413.spop)
	c:RegisterEffect(e0)
	--Must be Fusion Summoned or Special Summoned by banishing 2 monsters you control while this card's Level is equal to 1 of those monsters' Levels. (in which case you do not use Polymerization), and cannot be Special Summoned by other ways.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101010413.con)
	e3:SetOperation(c101010413.op)
	c:RegisterEffect(e3)
end
function c101010413.ffilter(c)
	return c:IsSetCard(0x8e7) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c101010413.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c101010413.spfilter1,tp,LOCATION_MZONE,0,2,nil,tp,c:GetLevel())
end
function c101010413.spfilter1(c,tp,djn)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101010413.spfilter2,tp,LOCATION_MZONE,0,1,c,djn,f,c:GetAttribute(),c:GetRace(),c:GetLevel())
end
function c101010413.spfilter2(c,djn,at,rc,lv)
	return c:IsFaceup() and c:GetAttribute()==at and c:GetRace()==rc
		and c:GetLevel()>0 and (djn==lv or djn==c:GetLevel()) and c:IsAbleToRemoveAsCost()
end
function c101010413.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,nil)
	local x=c:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m1=g:FilterSelect(tp,c500.spfilter1,1,1,nil,tp,x)
	local tc=m1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local m2=g:FilterSelect(tp,c500.spfilter2,1,1,tc,x,tc:GetAttribute(),tc:GetRace(),tc:GetLevel())
	m1:Merge(m2)
	Duel.Remove(m1,POS_FACEUP,REASON_COST)
end
function c101010413.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c101010413.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot Grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(c101010413.reptg)
	e5:SetReset(RESET_TODECK)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c101010413.rmcon)
	e6:SetTarget(c101010413.rmtg)
	e6:SetOperation(c101010413.rmop)
	e6:SetReset(RESET_TODECK)
	c:RegisterEffect(e6)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_REMOVE)
	e0:SetTarget(c101010413.sptg)
	e0:SetOperation(c101010413.rspop)
	e0:SetReset(RESET_TODECK)
	c:RegisterEffect(e0)
end
function c101010413.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetDestination()==LOCATION_GRAVE end
	return true
end
function c101010413.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end
function c101010413.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101010413.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010413.rspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	local tc=g:Select(tp,1,1,nil)
	if c:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(700)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c101010413.rmcon(e,tp,eg,ep,ev,re,r,rp)
	--if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp~=tp and g and g:IsContains(e:GetHandler())
end
function c101010413.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c101010413.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
