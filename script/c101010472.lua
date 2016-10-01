--Monument Steelsword
function c101010472.initial_effect(c)
	--Fusion Material: 2 Level 5 or lower LIGHT Machine-Type monsters
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101010472.ffilter,2,false)
	--Must first be Fusion Summoned with the above Fusion Materials.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--During either player's turn: You can target 1 of your banished Level 5 or lower LIGHT Machine-Type monsters; return that target to the Graveyard, then inflict damage to your opponent equal to that monster's Level x 300. You can only use this effect of "Monument Steelsword" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010472)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101010472.target)
	e2:SetOperation(c101010472.operation)
	c:RegisterEffect(e2)
end
function c101010472.ffilter(c)
	return c:IsLevelBelow(5) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010472.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101010472.ffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010472.ffilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101010472.ffilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetLevel()*300)
end
function c101010472.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,tc:GetLevel()*300,REASON_EFFECT)
	end
end
