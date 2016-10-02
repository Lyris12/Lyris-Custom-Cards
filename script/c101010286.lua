--Magmastar Dragon
function c101010286.initial_effect(c)
	c:EnableReviveLimit()
	--You can also Xyz Summon this card once per turn by banishing 1 Level 7 Dragon-Type monster you control whose ATK is between 2100 and 2800.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,101010286)
	e1:SetCondition(c101010286.xyzcon)
	e1:SetOperation(c101010286.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--This card can make a second attack during each Battle Phase, but if it does, your opponent takes no battle damage.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e3:SetCondition(c101010286.rdcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Once per turn, during your Standby Phase: You can target 1 Level 7 or lower Dragon-Type monster in your Graveyard; Special Summon that target, then if possible, detach 1 Xyz Material from this card, and if you do, the Summoned monster cannot be targeted or destroyed by card effects this turn.
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(c101010286.spcon)
	e4:SetTarget(c101010286.sptg)
	e4:SetOperation(c101010286.spop)
	c:RegisterEffect(e4)
	--cannot Grave (Do Not Remove)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge1:SetTargetRange(LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	ge1:SetCondition(function(e) local c=e:GetHandler() return c:GetOverlayCount()==0 or c:IsLocation(LOCATION_SZONE+LOCATION_OVERLAY) end)
	ge1:SetTarget(function(e,c) return c==e:GetHandler() end)
	ge1:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(ge1,0)
	if not c101010286.xyz_filter then
		c101010286.xyz_filter=function(mc) return mc:IsRace(RACE_DRAGON) and mc:IsXyzLevel(c,7) end
	end
end
c101010286.xyz_count=2
function c101010286.ovfilter(c,v,y,z)
	local atk=c:GetAttack()
	return c:GetLevel()==v and atk>=y and atk<=z and c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()
end
function c101010286.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if 2<=ct then return false end
	if ct<1 and not og and Duel.IsExistingMatchingCard(c101010286.ovfilter,tp,LOCATION_MZONE,0,1,nil,7,2100,2800) then
		return true
	end
	return Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),7,2,2,og)
end
function c101010286.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=-ft
		local b1=Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),7,2,2,og)
		local b2=ct<1 and Duel.IsExistingMatchingCard(c101010286.ovfilter,tp,LOCATION_MZONE,0,1,nil,7,2100,2800)
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(57707471,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=Duel.SelectMatchingCard(tp,c101010286.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,7,2100,2800)
			c:SetMaterial(mg)
			Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+REASON_XYZ)
		else
			local mg=Duel.SelectXyzMaterial(tp,c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),7,2,2)
			c:SetMaterial(mg)
			Duel.Overlay(c,mg)
		end
	end
end
function c101010286.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetAttackedCount()>1
end
function c101010286.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
--You can target 1 Level 7 or lower Dragon-Type monster in your Graveyard;
function c101010286.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010286.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010286.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101010286.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010286.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010286.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	--Special Summon that target
	if tc and tc:IsRelateToEffect(e) and tc:IsRace(RACE_DRAGON) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		--then if possible, detach 1 Xyz Material from this card
		if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
			Duel.BreakEffect()
			e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			--and if you do, the Summoned monster cannot be targeted or destroyed by card effects this turn
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
