--ＳＳＤ－フロント・ブロー
function c101010213.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c101010213.atkcon)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--When this card is Synchro Summoned: You can Special Summon 1 monster from your hand, and if you do, that monster gains this effect until the end of the turn. (below)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101010213.con)
	e2:SetTarget(c101010213.tg)
	e2:SetOperation(c101010213.op)
	c:RegisterEffect(e2)
end
function c101010213.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c101010213.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010213.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
