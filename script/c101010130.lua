--created & coded by Lyris
--Fate's Ritual Art
function c101010130.initial_effect(c)
	--When a card or effect is activated that targets exactly 1 card you control (and no other cards): Target another card on the field that would be an appropriate target for that card/effect; Tribute other cards from your hand or field, then Ritual Summon 1 "Fate's" Ritual Monster from your hand whose Level exactly equals the total Levels of those monsters, and if you do, that card/effect now targets the new target. You can only use the effect of "Fate's Ritual Art" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101010130)
	e1:SetCondition(c101010130.condition)
	e1:SetTarget(c101010130.target)
	e1:SetOperation(c101010130.activate)
	c:RegisterEffect(e1)
end
function c101010130.tfilter(c,tp)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE) and c:IsControler(tp)
end
function c101010130.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsOnField()
end
function c21501505.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp,e,tp,mg)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) and Duel.IsExistingMatchingCard(c101010130.rfilter,tp,LOCATION_HAND,0,1,c,e,tp,mg,c)
end
function c21501505.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsOnField() and c21501505.filter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingTarget(c21501505.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp,e,tp,mg)
	end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c21501505.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp,e,tp,mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101010130.rfilter(c,e,tp,m,tc)
	if not c:IsSetCard(0xf7a) or bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=nil
	if c.mat_filter then
		mg=m:Filter(c.mat_filter,c)
	else
		mg=m:Clone()
		mg:RemoveCard(c)
	end
	mg:RemoveCard(tc)
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c101010130.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetFirstTarget()
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c101010130.rfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,rg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc:IsFacedown() and tc:IsOnField() then Duel.ConfirmCards(1-tp,tc) end
		mg:RemoveCard(tc)
		if tc.mat_filter then
		   mg=mg:Filter(tc.mat_filter,nil)
		end
		mg:RemoveCard(rg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			Duel.ChangeTargetCard(ev,rg)
		end
	end
end
