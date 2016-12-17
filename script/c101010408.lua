--created & coded by Lyris
--Fate's Blue Lightning
function c101010408.initial_effect(c)
	c:EnableReviveLimit()
	--When this card is Ritual Summoned: You can target 1 other face-up monster you control, or 1 monster in your opponent's Graveyard if this card was Special Summoned with a "Fate's" card; Special Summon that target from the Graveyard, if possible, then regardless, inflict damage to your opponent equal to that target's original ATK.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101010408.condition)
	e1:SetTarget(c101010408.target)
	e1:SetOperation(c101010408.operation)
	c:RegisterEffect(e1)
end
function c101010408.mat_filter(c)
	return c:GetLevel()~=8
end
function c101010408.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c101010408.filter(c,e,tp)
	return c:IsFaceup() and (c:GetAttack()>0 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c101010408.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local loc=0
	if re:GetHandler():IsSetCard(0xf7a) then loc=LOCATION_GRAVE end
	if chkc then
		local res=(chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010408.filter(chkc,e,tp)) and chkc~=c
		if loc~=0 then res=(chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101010408.filter(chkc,e,tp)) or res
		end
		return res
	end
	if chk==0 then return Duel.IsExistingTarget(c101010408.filter,tp,LOCATION_MZONE,loc,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101010408.filter,tp,LOCATION_MZONE,loc,1,1,c,e,tp):GetFirst()
	if g:IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetAttack())
		return
	end
	e:SetCategory(CATEGORY_DAMAGE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetBaseAttack())
end
function c101010408.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_GRAVE) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
		end
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
