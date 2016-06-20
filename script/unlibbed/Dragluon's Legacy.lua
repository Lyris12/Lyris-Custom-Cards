--Dragluon's Legacy
function c101010196.initial_effect(c)
	--Target 1 Dragon-Type Xyz Monster in your Graveyard and 2 "Dragluo" cards in your Pendulum Zone; Special Summon the first target, and if you do, attach the second targets to it as Xyz Materials.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c101010194.sptg)
	e3:SetOperation(c101010194.spop)
	c:RegisterEffect(e3)
end
function c101010194.sfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010194.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chkc then return false end
	if chk==0 then
		if not pc1 or not pc2 then return end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010194.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and pc1:IsCanBeEffectTarget(e) and pc2:IsCanBeEffectTarget(e)
		and pc1:IsSetCard(0x94b) and pc2:IsSetCard(0x94b)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c101010194.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local og=Group.FromCards(pc1,pc2)
	Duel.SetTargetCard(og)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,og,2,0,0)
end
function c101010194.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex,sg=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc=sg:GetFirst()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--That monster cannot be destroyed by card effects.
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		local ex,og=Duel.GetOperationInfo(0,CATEGORY_LEAVE_GRAVE)
		Duel.Overlay(tc,og:Filter(Card.IsRelateToEffect,nil,e))
	end
end